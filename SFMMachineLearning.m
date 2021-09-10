% SFM Matlab Machine Learning

clear all
tic
raster_switch = 0;

if raster_switch == 1
    outdir = {};                                              % Enter dir/dirs with outfiles to be rastered - SFM 9/8/21
    convert_outfile_to_raster_format_sfm(outdir);
    cd(ourdir{end});
end

%% Preprocessing of Raster Data

rasterdir = 'F:\Data\sfm\Synthetic Test Data\Group6';         % Enter dir with rastered data if skipping the step from above - SFM 9/8/21
cd(rasterdir)
rasterlist = dir('*.mat');
preprocess_switch = 1;
decompression_switch = 0;

if preprocess_switch == 1
    for i = 1:length(rasterlist)                              % Let's put everything in order just in case - SFM 9/3/21
        presplit = strsplit(rasterlist(i).name, '_');
        presplit2 = strsplit(presplit{5}, 'c');
        dirindex = str2num(presplit2{3}); 
        fixeddir(dirindex) = rasterlist(i);
    end                             
    rasterlist = fixeddir;
    
    if decompression_switch == 1
        for i = 1:length(rasterlist)                          % Decompress any sparse coding scheme - SFM 9/8/21
            load(rasterlist(i).name);
            if exist('I', 'var')
                raster_data = zeros(raster_size);
                raster_data(I) = 1;
            else
            end
        end
    else
        load(rasterlist(i).name);                             % Still need at least one raster loaded to create other variables, assuming they are all the same - SFM 9/10/21
    end

    stimlog = raster_labels.sourcefile';                      % Simplify the labels, but keep the old ones - SFM 9/8/21
    for i = 1:length(stimlog)                                 % NOTE: We are assuming all cells have the same stimlog (should be the case) - SFM 9/9/21
        presplit = strsplit(stimlog{i}, '_');
        presplit2 = strsplit(presplit{4}, '+');
        newlabel = strcat(presplit2{1}, '-', presplit{5});
        stim{i} = newlabel;
    end    

    uniquestims = unique(stimlog);                            % Let's put everything in order just in case - SFM 9/3/21
    for k = 1:length(uniquestims)
        presplit = strsplit(uniquestims{k}, '_');
        dirindex = str2num(presplit{5});
        stimdir(dirindex) = uniquestims(k);
    end                             
    uniquestims = stimdir';

    stimindices = [];
    tempstimindices = [];
    for j = 1:length(uniquestims)
        for i = 1:length(stimlog)
            if strcmp(uniquestims{j}, stimlog{i}) == 1
                tempstimindices = [tempstimindices i];
            end
        end
        stimindices(j,:) = tempstimindices;
        tempstimindices = [];
    end

    stimindices = stimindices';
end
toc

%% Table Construction

xlim = -181.8672;                                               % Shouldn't ever change - SFM 9/8/21
samprate = raster_site_info.samprate;                           % Also shouldn't change, but just in case we will get it from the raster/out data - SFM 9/8/21
start_time = 175 - xlim;                                  
end_time = 365 - xlim;
start_time_samp = round((start_time/1000) * samprate);
end_time_samp = round((end_time/1000) * samprate);
hertzconv = round((1 / ((end_time - start_time) / 1000)), 2);   % Factor to multiple spike counts by to convert to Hertz - SFM 9/9/21
hertzconv_switch = 0;                                           % Switch on whether to convery spike counts to Hz - SFM 9/10/21

baindex = stimindices(:,1);
daindex = stimindices(:,10);

split_switch = 1;                                               % Binary on whether to create training and test split tables or one big table - SFM 9/10/21
split_point = 0.5;                                              % Portion of data you want selected for training the model - SFM 9/9/21
if split_switch == 1
    first_n_indices = round(length(baindex) * 0.5);
    baindex = baindex(randperm(length(baindex)));
    daindex = daindex(randperm(length(daindex)));
    dataindices_train = [baindex(1:first_n_indices); daindex(1:first_n_indices)];
    dataindices_train = sort(dataindices_train, 'ascend');      % Put all relevant indices together - SFM 9/9/21
    dataindices_test = [baindex((first_n_indices + 1):end); daindex((first_n_indices + 1):end)];
    dataindices_test = sort(dataindices_test, 'ascend');
else
    dataindices = [baindex; daindex];
    dataindices = sort(dataindices, 'ascend');
end

clear datatable datatable_train datatable_test
datatable = [];                                                 % Construct the data table from the raster data - SFM 9/8/21
if split_switch == 1
    datatable_train = [];
    datatable_test = [];
end
exclude_cells = [10:15];                                        % Array containing sites/neurons to exclude from the model - SFM 9/9/21
for i = 1:length(rasterlist)
    if ~isempty(setdiff(i, exclude_cells))
        clear raster_data I
        load(rasterlist(i).name);
        if ~exist('raster_data', 'var')
            raster_data = zeros(raster_size);
            raster_data(I) = 1;
        end
        if split_switch == 1
            for j = 1:length(dataindices_train)                 % ASSUMING the same number of training and testing indices (this is a faulty assumption) - SFM 9/10/21
                Ind_train(j) = sum(raster_data(dataindices_train(j), start_time_samp:end_time_samp));
                Ind_test(j) = sum(raster_data(dataindices_test(j), start_time_samp:end_time_samp));
            end
        else
            for j = 1:length(dataindices)
                Ind(j) = sum(raster_data(dataindices(j), start_time_samp:end_time_samp));
            end
        end
        if i == 1
            if split_switch == 1
                datatable_train = [Ind_train];
                datatable_test = [Ind_test];
            else
                datatable = [Ind];
            end
        else i ~= 1;
            if split_switch == 1
                datatable_train = [datatable_train; Ind_train];
                datatable_test = [datatable_test; Ind_test];
            else
                datatable = [datatable; Ind];
            end   
        end
    end
end

if hertzconv_switch == 1
    try
        datatable = datatable * hertzconv;
    catch
        datatable_train = datatable_train * hertzconv;
        datatable_test = datatable_test * hertzconv;
    end
end

if split_switch == 1
    datatable_supervised = table(datatable_train);
    datatable_unsupervised = table(datatable_test);
    % Stim = {'DA', 'DA', 'DA', 'DA', 'DA', 'DA', 'DA', 'DA', 'DA', 'noise', 'noise', 'noise', 'noise', 'noise', 'noise', 'BA', 'BA', 'BA', 'BA', 'BA', 'BA', 'BA', 'BA', 'BA', 'BA'}';
    Stim = {'DA', 'DA', 'DA', 'DA', 'DA', 'DA', 'DA', 'DA', 'DA', 'BA', 'BA', 'BA', 'BA', 'BA', 'BA', 'BA', 'BA', 'BA', 'BA'}';
    datatable_supervised = addvars(datatable_unsupervised, Stim);
else
    datatable_unsupervised = table(datatable);
    % Stim = {'DA', 'DA', 'DA', 'DA', 'DA', 'DA', 'DA', 'DA', 'DA', 'noise', 'noise', 'noise', 'noise', 'noise', 'noise', 'BA', 'BA', 'BA', 'BA', 'BA', 'BA', 'BA', 'BA', 'BA', 'BA'}';
    Stim = {'DA', 'DA', 'DA', 'DA', 'DA', 'DA', 'DA', 'DA', 'DA', 'BA', 'BA', 'BA', 'BA', 'BA', 'BA', 'BA', 'BA', 'BA', 'BA'}';
    datatable_supervised = addvars(datatable_unsupervised, Stim);
end
toc

groupname = strsplit(rasterdir, '\');
datatype = groupname{4};
groupname = groupname{end};
savedir = 'F:\Data\sfm\DataTables';
cd(savedir);
numtables = length(dir('*.mat'));
save_switch = 0;

if save_switch == 1
    if strcmp(datatype, 'Synthetic Test Data')
        savename_supervised = strcat('Synth', groupname, 'Supervised_', num2str(numtables + 1));
        savename_unsupervised = strcat('Synth', groupname, 'Unsupervised_', num2str(numtables + 1));
    else
        savename_supervised = strcat('ExperimentalDataSupervised_', num2str(numtables + 1));
        savename_unsupervised = strcat('ExperimentalDataUnsupervised_', num2str(numtables + 1));
    end
    save(savename_supervised, 'datatable_supervised'); 
    save(savename_unsupervised, 'datatable_unsupervised');
end

modeldir = 'F:\Data\sfm\Machine Learning Models';
cd(modeldir);

%%






