% load speech context outfiles and extract spikes into a matrix

clear
cd('/Users/sammehan/Documents/Wehr Lab/SpeechContext2021/ExpData')          % Set directory

%%% Settings
context_switch = 1;                                                         % Do you want all trials (1) or just BA-DA (0)?
fit_model_switch = 1;                                                       % Do you need to open Classification Learner and fit a model (1) ?
consonant_switch = 1;                                                       % Do you want to look at spikes during the whole consonant-vowel pair (0) or just the consonant (1)?
multi_bin_switch = 1;                                                       % Do you want to break the trials down in time (1) (Still need to hard code in new intervals)?
% xlim = -181.8672;

% trial-averaged
start = 195;
if consonant_switch == 1
    stop = 250;
elseif consonant_switch == 0
    stop = 300;
end
if multi_bin_switch == 1
    int_1 = 210;                                                            % Enter time intervals to bin by
    int_2 = 233;
    interval_factor = length(whos('int_*')) + 1;
    sc = [];
    time_intervals = [start int_1 int_2 stop];
else
end

% nreps = 100;                                                               % Hard code in expected nreps since true nreps/cell can be variable
load('MasterExpDataTable.mat')
cellsbystim_datatable = [];
for j = 1:length(masterdata)
    Stimtimes = masterdata(j).Stimetimes;
    for k = 1:size(Stimtimes, 1)
        spiketimes = (Stimtimes(k).spiketimes);                
        spikecount = length(find(spiketimes >= start & spiketimes <= stop));
        sc(k) = spikecount;
    end
    cellsbystim_datatable(j,:) = sc;
    sc = [];
end

%%%
% Single trials

iExclude = 0;
TotalTrialsByStim = [];
for j = 1:length(data)
    Trialtimes = data(j).Trialtimes(:,:);
    sc = [];
%     if size(Trialtimes, 4) >= 100
        for k = 1:size(Trialtimes, 1)
            index = 1;
            for rep = 1:size(Trialtimes, 2)
                spiketimes = Trialtimes(k, rep).spiketimes;
                if multi_bin_switch == 0
                    spikecount = length(find(spiketimes >= start & spiketimes <= stop));
                    sc(k, rep) = spikecount;
                elseif multi_bin_switch == 1
                    spikecount_int_1 = length(find(spiketimes >= start & spiketimes <= int_1));
                    spikecount_int_2 = length(find(spiketimes >= int_1 & spiketimes <= int_2));
                    spikecount_int_3 = length(find(spiketimes >= int_2 & spiketimes <= stop));
                    sc(k, index) = spikecount_int_1;
                    sc(k, index + 1) = spikecount_int_2;
                    sc(k, index + 2) = spikecount_int_3;
                    index = index + interval_factor;
                end
            end
        end
        Mtrials(j,:,:) = sc;                                            % Mtrials is cells x stimulus x rep
%     else
%         iExclude = iExclude + 1;
%         list_of_cells_excluded(iExclude) = j;
%     end    
end
StimList = (1:30)';

if context_switch == 0
    TotalTrialsByStim = TotalTrialsByStim(1:10, :)';
else
    TotalTrialsByStim = TotalTrialsByStim';
end

clear response CellsTrialAveragedExemplars
CellsTrialAveragedExemplars = [];
k = 1;
for i = [1 10]                                                          % Enter stims to train on in numerical form
    if multi_bin_switch == 0
        for j = 1:nreps
            StimID2(k) = i;
            CellsTrialAveragedExemplars(:, k) = Mtrials(:, i, j);
            k = k + 1;
        end
    elseif multi_bin_switch == 1
        for j = 1:(nreps * interval_factor)
            if j == 1 || rem(j, interval_factor) == 1
                StimID2(k) = i;
                StimID2(k + 1) = i;
                StimID2(k + 2) = i;
                CellsTrialAveragedExemplars(:, k) = Mtrials(:, i, j);
                CellsTrialAveragedExemplars(:, k + 1) = Mtrials(:, i, (j + 1));
                CellsTrialAveragedExemplars(:, k + 2) = Mtrials(:, i, (j + 2));
                k = k + interval_factor;
            else
            end
        end
    end    
end

StimID2_Coerce = zeros(length(StimID2), 1);
for i = 1:length(StimID2)
    if StimID2(i) == 1 || StimID2(i) == 10
        StimID2_Coerce(i) = StimID2(i);
    elseif StimID2(i) == 2 || StimID2(i) == 3 || StimID2(i) == 4 || StimID2(i) == 5 || StimID2(i) == 11 || StimID2(i) == 12 || StimID2(i) == 13 || StimID2(i) == 14 || StimID2(i) == 15 || StimID2(i) == 21 || StimID2(i) == 22 || StimID2(i) == 23 || StimID2(i) == 24 || StimID2(i) == 25
        StimID2_Coerce(i) = 1;
    elseif StimID2(i) == 6 || StimID2(i) == 7 || StimID2(i) == 8 || StimID2(i) == 9 || StimID2(i) == 16 || StimID2(i) == 17 || StimID2(i) == 18 || StimID2(i) == 19 || StimID2(i) == 20 || StimID2(i) == 26 || StimID2(i) == 27 || StimID2(i) == 28 || StimID2(i) == 29 || StimID2(i) == 30
        StimID2_Coerce(i) = 10;
    else
    end
end

% CellsTrialAveragedExemplars is cells x (stim * reps) and only has stimuli 1 and 10 (BA and DA)
% CellsTrialAveragedExemplars is designed to be input for classification learner

clear response CellsTrialAveragedAllBADA CellsTrialAveragedAllStims
if context_switch == 0
    CellsTrialAveragedAllBADA = [];
elseif context_switch == 1
    CellsTrialAveragedAllStims = [];
end
k = 1;
for i = stims
    if multi_bin_switch == 0
        for j = 1:nreps
            StimID3(k) = i;
            if context_switch == 0
                CellsTrialAveragedAllBADA(:, k) = Mtrials(:, i, j);
            elseif context_switch == 1
                CellsTrialAveragedAllStims(:, k) = Mtrials(:, i, j);
            end
            k = k + 1;
        end
    elseif multi_bin_switch == 1
        for j = 1:(nreps * interval_factor)
            if j == 1 || rem(j, interval_factor) == 1
                StimID3(k) = i;
                StimID3(k + 1) = i;
                StimID3(k + 2) = i;
                CellsTrialAveragedAllStims(:, k) = Mtrials(:, i, j);
                CellsTrialAveragedAllStims(:, k + 1) = Mtrials(:, i, j + 1);
                CellsTrialAveragedAllStims(:, k + 2) = Mtrials(:, i, j + 2);
                k = k + interval_factor;
            else
            end
        end
    end
end
% CellsTrialAveragedBADA is cells x (stim * reps)
% CellsTrialAveragedBADA is designed to be input for classification learner

StimID3_Coerce = zeros(length(StimID3), 1);
for i = 1:length(StimID3)
    if StimID3(i) == 1 || StimID3(i) == 10
        StimID3_Coerce(i) = StimID3(i);
    elseif StimID3(i) == 2 || StimID3(i) == 3 || StimID3(i) == 4 || StimID3(i) == 5 || StimID3(i) == 11 || StimID3(i) == 12 || StimID3(i) == 13 || StimID3(i) == 14 || StimID3(i) == 15 || StimID3(i) == 21 || StimID3(i) == 22 || StimID3(i) == 23 || StimID3(i) == 24 || StimID3(i) == 25
        StimID3_Coerce(i) = 1;
    elseif StimID3(i) == 6 || StimID3(i) == 7 || StimID3(i) == 8 || StimID3(i) == 9 || StimID3(i) == 16 || StimID3(i) == 17 || StimID3(i) == 18 || StimID3(i) == 19 || StimID3(i) == 20 || StimID3(i) == 26 || StimID3(i) == 27 || StimID3(i) == 28 || StimID3(i) == 29 || StimID3(i) == 30
        StimID3_Coerce(i) = 10;
    else
    end
end

