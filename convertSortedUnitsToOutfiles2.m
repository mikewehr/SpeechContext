
datadir = '/Users/sammehan/Documents/Wehr Lab/SpeechContext2021/ExpData';
cd(datadir);
all_MasterEvents = dir('MasterEvents*');
all_SortedUnits = dir('SortedUnits*');


for i = 1:length(all_SortedUnits)
    clear MasterEvents SortedUnits StartAcquisitionSec
    load(all_MasterEvents(i).name);
    load(all_SortedUnits(i).name);
    clear all_sourcefiles
    for j = 1:length(MasterEvents.Speech)
        if ~isempty(MasterEvents.Speech(j).sourcefile)
            all_sourcefiles(j) = convertCharsToStrings(MasterEvents.Speech(j).sourcefile);
        end
    end
    all_sourcefiles = rmmissing(all_sourcefiles);
    unique_sourcefiles = unique(all_sourcefiles);
    
    unique_sourcefiles = unique_sourcefiles([1 3 4 5 6 7 8 9 10 2 11 13 14 15 16 17 18 19 20 12 21 23 24 25 26 27 28 29 30 22]);
    for j = 1:length(unique_sourcefiles)
        temp_string = strsplit(unique_sourcefiles{j}, '_'); 
        stim_ID(j) = str2double(temp_string{5});
    end
    
    clear data mouse ID outfile_list 
    data.M1OFF = [];
    data.mM1OFF = [];
    stim_dur_ms = 363.734;
    stim_dur_samp = stim_dur_ms * 30;
    temp_string = strsplit(SortedUnits(1).dir, '-');
    mouseID = temp_string{end};
    aindex = 2;
    dindex = 2;
    
    for j = 1:length(SortedUnits)
        outname = strcat('outPSTH_ch', num2str(SortedUnits(j).channel), 'c', num2str(SortedUnits(j).cluster));
        outfile_list{j} = outname;
%         SortedUnits(j).spikesamps = SortedUnits(j).spiketimes * 30e3;
        for k = 1:length(unique_sourcefiles)
            stim_indices = find(strcmp(unique_sourcefiles{k}, {MasterEvents.Speech.sourcefile}));
            temp_spikes = [];
            for iTrial = 1:length(stim_indices)
                curr_spiketimes = []; adj_curr_spiketimes = []; data(j).M1OFF(k, aindex, dindex, iTrial).spiketimes = [];
                start_time = MasterEvents.Speech(stim_indices(iTrial)).soundcard_trigger_timestamp_sec;
                stop_time = start_time + (stim_dur_ms/1000);
                curr_spiketimes = SortedUnits(j).spiketimes(SortedUnits(j).spiketimes >= start_time & SortedUnits(j).spiketimes <= stop_time);
                if ~isempty(curr_spiketimes)
                    adj_curr_spiketimes = curr_spiketimes - start_time;
                    data(j).M1OFF(k, aindex, dindex, iTrial).spiketimes = [adj_curr_spiketimes data(j).M1OFF(k, aindex, dindex, iTrial).spiketimes];
                    temp_spikes = [temp_spikes, adj_curr_spiketimes]; 
                end
            end
        
        data(j).mM1OFF(k, aindex, dindex).spiketimes = sort(temp_spikes);
        end
    end
    
    savename = strcat('ExpDataTable-', num2str(mouseID));
    save(savename, 'data', 'mouseID', 'outfile_list');
end
    
    