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

if preprocess_switch == 1
    for i = 1:length(rasterlist)                              % Let's put everything in order just in case - SFM 9/3/21
        presplit = strsplit(rasterlist(i).name, '_');
        presplit2 = strsplit(presplit{5}, 'c');
        dirindex = str2num(presplit2{3});
        fixeddir(dirindex) = rasterlist(i);
    end                             
    rasterlist = fixeddir;

%     for i = 1:length(rasterlist)                              % Decompress any sparse coding scheme - SFM 9/8/21
        load(rasterlist(i).name);
%         if exist('I', 'var')
%             raster_data = zeros(raster_size);
%             raster_data(I) = 1;
%         else
%         end
%     end

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

xlim = -181.8672;                                   % Shouldn't ever change - SFM 9/8/21
samprate = raster_site_info.samprate;               % Also shouldn't change, but just in case we will get it from the raster/out data - SFM 9/8/21
start_time = 175 - xlim;                            %  
end_time = 365 - xlim;
start_time_samp = round((start_time/1000) * samprate);
end_time_samp = round((end_time/1000) * samprate);
hertzconv = round((1 / ((end_time - start_time) / 1000)), 2);   % Factor to multiple spike counts by to convert to Hertz - SFM 9/9/21
hertzconv_switch = 0;

baindex = stimindices(:,1);
daindex = stimindices(:,10);

split_switch = 1;
split_point = 0.5;                                  % Portion of data you want selected for training the model - SFM 9/9/21
if split_switch == 1
    first_n_indices = round(length(baindex) * 0.5);
    baindex = baindex(randperm(length(baindex)));
    daindex = daindex(randperm(length(daindex)));
    dataindices = [baindex(1:first_n_indices); daindex(1:first_n_indices)];
    dataindices = sort(dataindices, 'ascend');      % Put all relevant indices together - SFM 9/9/21
else
    dataindices = [baindex; daindex];
    dataindices = sort(dataindices, 'ascend');
end
 
clear datatable
datatable = [];                                     % Construct the data table from the raster data - SFM 9/8/21
exclude_sites = [];                                 % Array containing sites/neurons to exclude from the model - SFM 9/9/21
for i = 1:length(rasterlist)
    if ~isempty(setdiff(i, exclude_cells))
        clear raster_data I
        load(rasterlist(i).name);
        if ~exist('raster_data', 'var')
            raster_data = zeros(raster_size);
            raster_data(I) = 1;
        end
        for j = 1:length(dataindices)
            Ind(j) = sum(raster_data(dataindices(j), start_time_samp:end_time_samp));
        end
        if i == 1
            datatable = [Ind];
        else
            datatable = [datatable; Ind];
        end
    end
end

if hertzconv_switch == 1
    datatable = datatable * hertzconv;
end

datatable_pre = table(datatable);
Stim = {'DA', 'DA', 'DA', 'DA', 'DA', 'DA', 'DA', 'DA', 'DA', 'noise', 'noise', 'noise', 'noise', 'noise', 'noise', 'BA', 'BA', 'BA', 'BA', 'BA', 'BA', 'BA', 'BA', 'BA', 'BA'};
StimTest = {'DA', 'DA', 'DA', 'DA', 'DA', 'DA', 'DA', 'DA', 'DA', 'BA', 'BA', 'BA', 'BA', 'BA', 'BA', 'BA', 'BA', 'BA', 'BA'};
Stim = Stim';
StimTest = StimTest';
datatable_supervised = addvars(datatable_pre, StimTest);
stim_unsupervised = cell(length(rasterlist), 1);
datatable_unsupervised = addvars(datatable_pre, stim_unsupervised);

toc

groupname = strsplit(rasterdir, '\');
datatype = groupname{4};
groupname = groupname{end};
savedir = 'F:\Data\sfm\DataTables';
cd(savedir);
numtables = length(dir('*.mat'));

if strcmp(datatype, 'Synthetic Test Data')
    savename_supervised = strcat('Synth', groupname, 'Supervised_', num2str(numtables + 1));
    savename_unsupervised = strcat('Synth', groupname, 'Unsupervised_', num2str(numtables + 1));
else
    savename_supervised = strcat('ExperimentalDataSupervised_', num2str(numtables + 1));
    savename_unsupervised = strcat('ExperimentalDataUnsupervised_', num2str(numtables + 1));
end

save_switch = 0;

if save_switch == 1
    save(savename_supervised, 'datatable_supervised'); 
    save(savename_unsupervised, 'datatable_unsupervised');
end


%%






