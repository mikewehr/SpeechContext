function [ProcessedDatatable] = makeProcessedDatatable(varargin)

    masterdirs = varargin;
    if isempty(varargin)
        error('You gotta add some directories to process!')
    end

    for i = 1:length(masterdirs)
        cd(masterdirs{i});
        MasterDir = masterdirs{i};
        EphysPath = masterdirs{i};
        temp_string = strsplit(EphysPath, '\');
        LocalDataRoot = strcat(temp_string{1}, '\', temp_string{2}, '\', temp_string{3}, '\');
        temp_str = strsplit(EphysPath, '-');
        mouseID = temp_str{end};
        load('dirs.mat');
        for i = 1:length(dirs)
            [SortedUnitsFile] = ProcessSpikes(dirs{i}, LocalDataRoot);
            if i == 1
                SortedUnits = SortedUnitsFile;
            end
            for j = 1:length(SortedUnits)
                SortedUnits(j).spiketimes = [SortedUnits(j).spiketimes SortedUnitsFile(j).spiketimes];
            end
            clear SortedUnitsFile
        end
        % load rez, which contains number of samples of each recording 1=1, 2=1+2,
        % 3=1+2+3, etc
        load(fullfile(MasterDir,'rez.mat'))
        L=(rez.ops.recLength)/sp.sample_rate;
        save(fullfile(MasterDir,'RecLengths.mat'),'L')
        
        savename = strcat('SortedUnits-', mouseID);
        save(fullfile(MasterDir, savename), 'L');

        ProcessAllEvents(MasterDir);
    end
end


