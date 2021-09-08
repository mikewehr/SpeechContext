% SFM Matlab Machine Learning

tic
raster_switch = 0;

if raster_switch == 1
    outdir = {};                                          % Enter dir/dirs with outfiles to be rastered - SFM 9/8/21
    convert_outfile_to_raster_format_sfm(outdir)
    cd(ourdir{end});
else
end

rasterdir = 'F:\Data\sfm\Synthetic Test Data\Group6';     % Enter dir with rastered data if skipping the step from above - SFM 9/8/21
cd(rasterdir)
rasterlist = dir('*.mat');

%% Preprocessing of Raster Data

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
for i = 1:length(stimlog)
    stimindices(i) = strcmp(uniquestims{i}, stimlog{i});
end
baindex = stimindices(1);
daindex = stimindices(10);

toc









