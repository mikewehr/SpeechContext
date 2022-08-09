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
        
        try
            load(fullfile(MasterDir,'RecLengths.mat'))
        catch
            % load rez, which contains number of samples of each recording 1=1, 2=1+2,
            % 3=1+2+3, etc
            load(fullfile(MasterDir,'rez.mat'))
            L = (rez.ops.recLength)/sp.sample_rate;
            save(fullfile(MasterDir,'RecLengths.mat'),'L')
        end
        
        load(fullfile(MasterDir, 'dirs.mat'));
        for i = 1:length(dirs)
            [SortedUnitsFile] = ProcessSpikes(dirs{i}, LocalDataRoot);
            load(SortedUnitsFile);
            if i == 1
                AllSortedUnits = SortedUnits;
            end
            for j = 1:length(SortedUnits)
                if i >= 2
                    start = L(currentdir_indx - 1);
                    SortedUnits(j).spiketimes = SortedUnits(j).spiketimes + start;
                end
                AllSortedUnits(j).spiketimes = [AllSortedUnits(j).spiketimes SortedUnits(j).spiketimes];
            end
            clear SortedUnitsFile
        end
        
        SortedUnits = AllSortedUnits;
        savename = strcat('SortedUnits-', mouseID);
        save(fullfile(MasterDir, savename), 'L');

        ProcessAllEvents(MasterDir);
    end
end


