% SFM Matlab Machine Learning

clear
tic
raster_switch = 0;

if raster_switch == 1
    outdir = {};                                              % Enter dir/dirs with outfiles to be rastered - SFM 9/8/21
    convert_outfile_to_raster_format_sfm(outdir);
    cd(ourdir{end});
end

%% Preprocessing of Raster Data

rasterdir = 'F:\Data\sfm\RasterFiles';
%'F:\Data\sfm\Synthetic Test Data\Group10';         % Enter dir with rastered data if skipping the step from above - SFM 9/8/21
cd(rasterdir)
rasterlist = dir('*.mat');
preprocess_switch = 1;
decompression_switch = 0;
real_data = 1;                                                % Binary switch on whether to organize synthetic data, won't work with real data - SFM 9/13/21

if preprocess_switch == 1
    if real_data == 0
        for i = 1:length(rasterlist)                          % Let's put everything in order just in case, but only for synth data! - SFM 9/3/21
            presplit = strsplit(rasterlist(i).name, '_');
            presplit2 = strsplit(presplit{5}, 'c');
            dirindex = str2num(presplit2{3}); 
            fixeddir(dirindex) = rasterlist(i);
        end                             
        rasterlist = fixeddir;
    end
    
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
        load(rasterlist(1).name);                             % Still need at least one raster loaded to create other variables, assuming they are all the same - SFM 9/10/21
    end                                                       % 80 reps/stim - SFM 9/14/21

    stimlog = raster_labels.sourcefile';                      % Simplify the labels, but keep the old ones - SFM 9/8/21
    for i = 1:600                                             % NOTE: We are assuming all cells have the same stimlog (should be the case) - SFM 9/9/21
        presplit = strsplit(stimlog{i}, '_');
        presplit2 = strsplit(presplit{4}, '+');
        newlabel = strcat(presplit2{1}, '-', presplit{5});
        stim{i} = newlabel;
    end
%    stim = [stim; stim];                                      % The more flexible way to do this is to only shorten labels for the first cycle and then replicate that X times for X number of repeats - SFM 9/13/21

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

% baindex = stimindices(:,1);
% daindex = stimindices(:,10);
label_1 = stimindices(:,1);
label_2 = stimindices(:,2);
label_3 = stimindices(:,3);
label_4 = stimindices(:,4);
label_5 = stimindices(:,5);
label_6 = stimindices(:,6);
label_7 = stimindices(:,7);
label_8 = stimindices(:,8);
label_9 = stimindices(:,9);
label_10 = stimindices(:,10);
label_11 = stimindices(:,11);
label_12 = stimindices(:,12);
label_13 = stimindices(:,13);
label_14 = stimindices(:,14);
label_15 = stimindices(:,15);
label_16 = stimindices(:,16);
label_17 = stimindices(:,17);
label_18 = stimindices(:,18);
label_19 = stimindices(:,19);
label_20 = stimindices(:,20);
label_21 = stimindices(:,21);
label_22 = stimindices(:,22);
label_23 = stimindices(:,23);
label_24 = stimindices(:,24);
label_25 = stimindices(:,25);
label_26 = stimindices(:,26);
label_27 = stimindices(:,27);
label_28 = stimindices(:,28);
label_29 = stimindices(:,29);
label_30 = stimindices(:,30);
% list_of_stims_to_test = {'ba-da1-1', 'ba-da2-2', 'ba-da3-3', 'ba-da4-4', 'ba-da5-5', 'ba-da6-6', 'ba-da7-7', 'ba-da8-8', 'ba-da9-9', 'ba-da10-10'};
% num_relevant_labels = 10;                                       % How many types of stimuli do you want to make the model with? - SFM 9/10/21

split_switch = 0;                                               % Binary on whether to create training and test split tables or one big table - SFM 9/10/21
split_point = 0.5;                                              % Portion of data you want selected for training the model - SFM 9/9/21
if split_switch == 1
%     for k = 1:length(num_relevant_trials)
%         first_n_indices = round(length(list_of_stims_to_test{k}) * 0.5);

        first_n_indices = round(length(baindex) * 0.5);
        baindex = baindex(randperm(length(baindex)));
        daindex = daindex(randperm(length(daindex)));
        dataindices_train = [baindex(1:first_n_indices); daindex(1:first_n_indices)];
        dataindices_train = sort(dataindices_train, 'ascend');  % Put all relevant indices together - SFM 9/9/21
        dataindices_test = [baindex((first_n_indices + 1):end); daindex((first_n_indices + 1):end)];
        dataindices_test = sort(dataindices_test, 'ascend');
%     end
else
%     dataindices = [baindex; daindex];
%     dataindices = [label_1; label_2; label_3; label_4; label_5; label_6; label_7; label_8; label_9; label_10]; 
    dataindices = [label_1; label_2; label_3; label_4; label_5; label_6; label_7; label_8; label_9; label_10; label_11; label_12; label_13; label_14; label_15; label_16; label_17; label_18; label_19; label_20; label_21; label_22; label_23; label_24; label_25; label_26; label_27; label_28; label_29; label_30]; 
    dataindices = sort(dataindices, 'ascend');
end

clear datatable datatable_train datatable_test                                                
if split_switch == 1
    datatable_train = [];
    datatable_test = [];
else
    datatable = []; 
end
exclude_cells = [];                                             % Array containing sites/neurons to exclude from the model - SFM 9/9/21
list_of_cells_excluded = {};                                    % If a cell doesn't have the minimum num of repeats, return the name just in case - SFM 9/14/21
min_trials = 80;                                                % Set minimum number of repetitions each cell needs to have to be included - SFM 9/14/21
min_indices = min_trials * length(uniquestims);                 

for i = 1:length(rasterlist)                                    % Construct the data table from the raster data - SFM 9/8/21
    if ~isempty(setdiff(i, exclude_cells))
        clear raster_data I raster_labels
        load(rasterlist(i).name);
        if ~exist('raster_data', 'var')
            raster_data = zeros(raster_size);
            raster_data(I) = 1;
        end
        if split_switch == 1
            for j = 1:length(dataindices_train)                 % ASSUMING the same number of training and testing indices (this is a faulty assumption) - SFM 9/10/21
                Ind_train(j) = sum(raster_data(dataindices_train(j), start_time_samp:end_time_samp));
            end
            for j = 1:length(dataindices_test)
                Ind_test(j) = sum(raster_data(dataindices_test(j), start_time_samp:end_time_samp));
            end
        else
            if length(raster_labels.sourcefile) >= min_indices
                for j = 1:length(dataindices)
                    Ind(j) = sum(raster_data(dataindices(j), start_time_samp:end_time_samp));
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
            else
                list_of_cells_excluded{i} = rasterlist(i).name;
            end
        end
    end
end

list_of_cells_excluded(~cellfun('isempty', list_of_cells_excluded));
if hertzconv_switch == 1
    try
        datatable_train = datatable_train * hertzconv;
        datatable_test = datatable_test * hertzconv;
    catch
        datatable = datatable * hertzconv;
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
%     Stim = {'DA', 'DA', 'DA', 'DA', 'DA', 'DA', 'DA', 'DA', 'DA', 'noise', 'noise', 'noise', 'noise', 'noise', 'noise', 'BA', 'BA', 'BA', 'BA', 'BA', 'BA', 'BA', 'BA', 'BA', 'BA'}';
%     Stim = {'DA', 'DA', 'DA', 'DA', 'DA', 'DA', 'DA', 'DA', 'DA', 'BA', 'BA', 'BA', 'BA', 'BA', 'BA', 'BA', 'BA', 'BA', 'BA'}';
%     datatable_supervised = addvars(datatable_unsupervised, Stim);
end
toc

groupname = strsplit(rasterdir, '\');
datatype = groupname{4};
groupname = groupname{end};
savedir = 'F:\Data\sfm\DataTables';
cd(savedir);
numtables = length(dir('*.mat'));
save_switch = 1;

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






