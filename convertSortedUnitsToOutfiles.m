

masterdirs = {'F:\Data\sfm\2022-03-31_11-21-18_mouse-0956\2022-03-31_11-21-26_mouse-0956'};

for i = 1:length(masterdirs)
    cd(masterdirs{i});
    curr_contents = dir('MasterEvents*');
    load(curr_contents(1).name);
    curr_contents = dir('SortedUnits-*');
    load(curr_contents(1).name);
    for j = 1:length(MasterEvents.Speech)
        if ~isempty(MasterEvents.Speech(j).sourcefile)
            all_sourcefiles(j) = convertCharsToStrings(MasterEvents.Speech(j).sourcefile);
        end
    end
%     for j = 1:length(MasterEvents.Tuning)
%         if ~isempty(MasterEvents.Tuning(j).frequency)
%             all_frequencies(j) = MasterEvents.Tuning(j).frequency;
%         end
%         if ~isempty(MasterEvents.Tuning(j).amplitude)
%             all_amplitudes(j) = MasterEvents.Tuning(j).amplitude;
%         end
%     end
%     all_frequencies = rmmissing(all_frequencies);
%     unique_frequencies = unique(all_frequencies);
%     unique_amplitudes = unique(all_amplitudes);

    all_sourcefiles = rmmissing(all_sourcefiles);
    unique_sourcefiles = unique(all_sourcefiles);
    
    unique_sourcefiles = unique_sourcefiles([1 3 4 5 6 7 8 9 10 2 11 13 14 15 16 17 18 19 20 12 21 23 24 25 26 27 28 29 30 11]);
    for j = 1:length(unique_sourcefiles)
        temp_string = strsplit(unique_sourcefiles{j}, '_'); 
        stim_ID(j) = str2double(temp_string{5});
    end
    
    data = [];
    data.M1OFF = [];
    data.mM1OFF = [];
    stim_dur_ms = 363.734;
    stim_dur_samp = stim_dur_ms * 30;
    temp_string = strsplit(masterdirs{i}, '-');
    mouseID = temp_string{end};
    
    for j = 1:length(SortedUnits)
        outname = strcat('outPSTH_ch', num2str(SortedUnits(j).channel), 'c', num2str(SortedUnits(j).cluster));
        outfile_list{j} = outname;
        SortedUnits(j).spikesamps = SortedUnits(j).spiketimes * 30e3;
        for k = 1:length(unique_sourcefiles)
            stim_indices = strcmp(unique_sourcefiles{k}, all_sourcefiles);
            stim_indices = find(stim_indices == 1);
            temp_spikes = [];
            for iTrial = 1:length(stim_indices)
                start_samp = MasterEvents.Speech(stim_indices(iTrial)).message_timestamp_samples;
                stop_samp = start_samp + stim_dur_samp;
                data(j).mM1OFF(k, iTrial).spikesamps = SortedUnits(j).spikesamps(SortedUnits(j).spikesamps >= start_samp & SortedUnits(j).spikesamps <= stop_samp);
                temp_spikes = [temp_spikes, SortedUnits(j).spikesamps(SortedUnits(j).spikesamps >= start_samp & SortedUnits(j).spikesamps <= stop_samp)]; 
            end
        data(j).M1OFF(k).spikesamps = temp_spikes;
        end
    end
    
    savename = strcat('ExpDataTable-', num2str(mouseID));
    save(savename, 'data', 'mouseID', 'outfile_list');
end
    
    