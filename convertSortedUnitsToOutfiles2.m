
datadir = '/Users/sammehan/Documents/Wehr Lab/SpeechContext2021/ExpData';
cd(datadir);

all_MasterEvents = dir('MasterEvents*');
all_SortedUnits = dir('SortedUnits*');
masterdata = [];
masterMouseID = {};
masterOutfile_list = {};

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
    
    clear data mouseID outfile_list all_mouseID
    data.Trialtimes = [];
    data.Stimtimes = [];
    stim_dur_ms = MasterEvents.Speech(1).duration;                           % Assuming constant stimulus duration
    stim_dur_sec = stim_dur_ms/1000;
    stim_dur_samp = stim_dur_ms * 30;
    temp_string = strsplit(SortedUnits(1).dir, '-');
    mouseID = temp_string{end};
    
    for j = 1:length(SortedUnits)
        outname = strcat('outPSTH_ch', num2str(SortedUnits(j).channel), 'c', num2str(SortedUnits(j).cluster));
        outfile_list{j} = outname;
        all_mouseID{j} = mouseID;
        for k = 1:length(unique_sourcefiles)
            stim_indices = find(strcmp(unique_sourcefiles{k}, {MasterEvents.Speech.sourcefile}));
            temp_spikes = [];
            for iTrial = 1:length(stim_indices)
                curr_spiketimes = []; adj_curr_spiketimes = []; 
                start_time = MasterEvents.Speech(stim_indices(iTrial)).soundcard_trigger_timestamp_sec;
                if start_time < SortedUnits(j).spiketimes(end) == 1
                    data(j).Trialtimes(k, iTrial).spiketimes = [];
                    stop_time = start_time + (stim_dur_sec);
                    curr_spiketimes = SortedUnits(j).spiketimes(SortedUnits(j).spiketimes >= start_time & SortedUnits(j).spiketimes <= stop_time);
%                     if ~isempty(curr_spiketimes)
                        adj_curr_spiketimes = (curr_spiketimes - start_time) * 1000; %Adjust to start of trial and convert to ms
                        data(j).Trialtimes(k, iTrial).spiketimes = [data(j).Trialtimes(k, iTrial).spiketimes adj_curr_spiketimes];
                        temp_spikes = [temp_spikes, adj_curr_spiketimes]; 
%                     end
                end
            end
        
        data(j).Stimtimes(k).spiketimes = sort(temp_spikes);
        end
    end
    
    savename = strcat('ExpDataTable-', num2str(mouseID));
    save(savename, 'data', 'mouseID', 'outfile_list');
    
    masterdata = [masterdata data];
    masterMouseID = [masterMouseID, all_mouseID];
    masterOutfile_list = [masterOutfile_list, outfile_list];
    
end
    
save('MasterExpDataTable.mat', 'masterdata', 'masterMouseID', 'masterOutfile_list', '-v7.3');


