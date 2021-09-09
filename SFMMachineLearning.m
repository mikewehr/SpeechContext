% SFM Matlab Machine Learning

clear all
tic
raster_switch = 0;

if raster_switch == 1
    outdir = {};                                              % Enter dir/dirs with outfiles to be rastered - SFM 9/8/21
    convert_outfile_to_raster_format_sfm(outdir)
    cd(ourdir{end});
else
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

    for i = 1:length(rasterlist)                              % Decompress any sparse coding scheme - SFM 9/8/21
        load(rasterlist(i).name);
        if exist('I', 'var')
            raster_data = zeros(raster_size);
            raster_data(I) = 1;
        else
        end
    end

    stimlog = raster_labels.sourcefile';                      % Simplify the labels, but keep the old ones - SFM 9/8/21
    for i = 1:length(stimlog)
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
    baindex = stimindices(:,1);
    daindex = stimindices(:,10);
else
end
toc

%% Table Construction

xlim = -181.8672;                               % Shouldn't ever change - SFM 9/8/21
samprate = raster_site_info.samprate;           % Also shouldn't change, but just in case we will get it from the raster/out data - SFM 9/8/21
start_time = 175 - xlim;                        % 
end_time = 365 - xlim;
start_time_samp = round((start_time/1000) * samprate);
end_time_samp = round((end_time/1000) * samprate);
hertzconv = round((1 / ((end_time - start_time) / 1000)), 2);

dataindices = [baindex; daindex];
dataindices = sort(dataindices, 'ascend');          % Put all relevant indices together
 
clear datatable
datatable = [];                                  % Construct the data table from the raster data - SFM 9/8/21
for i = 1:length(rasterlist)
    clear raster_data I
    load(rasterlist(i).name);
    if ~exist('raster_data', 'var')
        raster_data = zeros(raster_size);
        raster_data(I) = 1;
    else
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

datatable_unsupervised = table(datatable);
Stim = {'DA', 'DA', 'DA', 'DA', 'DA', 'DA', 'DA', 'DA', 'DA', 'noise', 'noise', 'noise', 'noise', 'noise', 'noise', 'BA', 'BA', 'BA', 'BA', 'BA', 'BA', 'BA', 'BA', 'BA', 'BA'};
Stim = Stim';
datatable_supervised = addvars(datatable_unsupervised, Stim);

toc

groupname = strsplit(rasterdir, '\');
datatype = groupname{4};
groupname = groupname{end};
savedir = 'F:\Data\sfm\DataTables';
cd(savedir);
numtables = length(dir('*.mat'));

if strcmp(datatype, 'Synthetic Test Data')
    savename_supervised = strcat('Synth', groupname, 'Supervised', num2str(numtables + 1));
    savename_unsupervised = strcat('Synth', groupname, 'Unsupervised', num2str(numtables + 1));
else
    savename_supervised = strcat('ExperimentalDataSupervised', num2str(numtables + 1));
    savename_unsupervised = strcat('ExperimentalDataUnsupervised', num2str(numtables + 1));
end

save_switch = 0;

if save_switch == 1
    save(savename_supervised, 'datatable_supervised'); 
    save(savename_unsupervised, 'datatable_unsupervised');
else
end


%%






