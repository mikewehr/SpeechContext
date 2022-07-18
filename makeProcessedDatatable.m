

%masterdirs = list of dirs to analyze

for i = 1:length(masterdirs)
    cd(masterdirs{1});
    load('dirs.mat', 'notebook.mat')
    masterstimlog = stimlog;
    temp_str = strsplit(dirs{1}, '\');
    mouseID = str2double(temp_str{end});
    for j = 2:length(dirs)
        cd(dirs{j})
        load('notebook.mat')
        for field = fieldnames(stimlog)
            fname = field{1};
            masterstimlog.(fname) = vertcat(stimlog.(fname));
        end 
    end
    fields = {'LaserOnOff', 'LaserStart', 'LaserWidth', 'LaserNumPulses', 'LaserISI'};
    masterstimlog = rmfield(masterstimlog, fields);
    savename = strcat('MasterStimlog-', num2str(mouseID));
    load('rez.mat');
    save(savename, 'masterstimlog', 'rez');
end


for i = 1:length(masterdirs)
    cd(masterdirs{i});
    SortedUnits = load(dir('SortedUnits*'));
    temp_strsplit = strsplit(SortedUnits(1).dir, '-');
    mouseID = str2double(temp_strsplit{end});
    SortedUnits(end, :) = mouseID;
    savename = strcat('SortedUnits-', num2str(mouseID));
    load('RecLengths.mat');
    save(savename, 'SortedUnits', 'L')
end

