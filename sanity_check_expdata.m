% load speech context outfiles and extract spikes into a matrix

clear
tic
cd('/Users/sammehan/Documents/Wehr Lab/SpeechContext2021/Data_V1')          % Set directory

%%% Settings
plot_switch = 0;                                                            % Do you want all of the diagnostic plots (1)? (neurometric curve plots not included)
context_switch = 1;                                                         % Do you want all trials (1) or just BA-DA (0)?
fit_model_switch = 1;                                                       % Do you need to open Classification Learner and fit a model (1) ?
consonant_switch = 1;                                                       % Do you want to look at spikes during the whole consonant-vowel pair (0) or just the consonant (1)?
multi_bin_switch = 0;                                                       % Do you want to break the trials down in time (1) (Still need to hard code in new intervals)?


% if ~exist('ExpDataTable.mat', 'file')
%     d = dir('outPSTH*.mat');
%     for i = 1:length(d)
%         fprintf('\n%d/%d', i, length(d))
%         outfilename = sprintf('outPSTH_combined_ch%dc%d.mat', i, i);
%         out = load(outfilename);
%         data(i).M1OFF = out.out.M1OFF;
%         data(i).mM1OFF = out.out.mM1OFF;
%     end
%     save('ExpDataTable', 'data');
%     nreps = max(out.out.nreps(:));
% else
%     load('ExpDataTable.mat');
%     nreps = 100;
% end
% 
% for i = 1:length(data)
%     data(i).M1OFF = data(i).M1OFF([1 3 4 5 6 7 8 9 10 2 11 13 14 15 16 17 18 19 20 12 21 23 24 25 26 27 28 29 30 22], :, :, :);
%     data(i).mM1OFF = data(i).mM1OFF([1 3 4 5 6 7 8 9 10 2 11 13 14 15 16 17 18 19 20 12 21 23 24 25 26 27 28 29 30 22], :, :);
% end

load('ExpDataTable.mat', 'data', 'mouseID', 'outfile_list');
nreps = 100;                                                                % Hard code in expected nreps since true nreps/cell can be variable

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
%     int_3 = 233;
    interval_factor = length(whos('int_*')) + 1;
    sc = [];
%     time_intervals = [start int_1 stop];
    time_intervals = [start int_1 int_2 stop];
else
end

for j = 1:length(data)
    mM1OFF = data(j).mM1OFF(:,2,2,1);
    for k = 1:length(mM1OFF)
        spiketimes = mM1OFF(k).spiketimes;
        if multi_bin_switch == 0
            spikecount = length(find(spiketimes >= start & spiketimes <= stop));
            sc(k) = spikecount;
        elseif multi_bin_switch == 1
            spikecount_int_1 = length(find(spiketimes >= start & spiketimes <= int_1));
            spikecount_int_2 = length(find(spiketimes >= int_1 & spiketimes <= int_2));
            spikecount_int_3 = length(find(spiketimes >= int_2 & spiketimes <= stop));
%             spikecount_int_4 = length(find(spiketimes >= int_3 & spiketimes <= stop));
%             sc = [sc spikecount_int_1 spikecount_int_2];
            sc = [sc spikecount_int_1 spikecount_int_2 spikecount_int_3];
        end
    end
    cellsbystim_datatable(j,:) = sc;
    sc = [];
end

if plot_switch == 1
    figure
    imagesc(cellsbystim_datatable(:, 1:10))
    colormap jet
    xlabel('stimulus')
    ylabel('cell')
    title([group, ' trial-averaged'])

    figure
    plot(cellsbystim_datatable(1,1:30), cellsbystim_datatable(25,1:30), 'o')
    ax = axis;
    xlabel('cell 1')
    ylabel('cell 25')
    
    figure
    for i = 1:size(cellsbystim_datatable, 2)
        text(cellsbystim_datatable(1,i), cellsbystim_datatable(25, i),int2str(i))
    end
    xlabel('cell 1')
    ylabel('cell 25')
    axis(ax)
end

%%%
% Single trials

iExclude = 0;

TotalTrialsByStim = [];
for j = 1:length(data)
    M1OFF = data(j).M1OFF(:,2,2,:);
    if size(M1OFF, 4) >= 100
        for k = 1:size(M1OFF, 1)
            index = 1;
            for rep = 1:nreps                                           % or 1:size(M1OFF, 4)
                spiketimes = M1OFF(k, 1, 1, rep).spiketimes;
                if multi_bin_switch == 0
                    spikecount = length(find(spiketimes >= start & spiketimes <= stop));
                    sc(k, rep) = spikecount;
                elseif multi_bin_switch == 1
                    spikecount_int_1 = length(find(spiketimes >= start & spiketimes <= int_1));
                    spikecount_int_2 = length(find(spiketimes >= int_1 & spiketimes <= int_2));
                    spikecount_int_3 = length(find(spiketimes >= int_2 & spiketimes <= stop));
%                     spikecount_int_4 = length(find(spiketimes >= int_3 & spiketimes <= stop));
                    sc(k, index) = spikecount_int_1;
                    sc(k, index + 1) = spikecount_int_2;
                    sc(k, index + 2) = spikecount_int_3;
%                     sc(k, index + 3) = spikecount_int_4;
                    index = index + interval_factor;
                end
            end
        end
        Mtrials(j,:,:) = sc;                                            % Mtrials is cells x stimulus x rep
        TotalTrialsByStim = [TotalTrialsByStim sc];
    else
        iExclude = iExclude + 1;
        list_of_cells_excluded(iExclude) = j;
    end    
end
StimList = (1:30)';

if context_switch == 0
    TotalTrialsByStim = TotalTrialsByStim(1:10, :)';
else
    TotalTrialsByStim = TotalTrialsByStim';
end
if plot_switch == 1
    figure
    imagesc(TotalTrialsByStim)
    xlabel('stimulus')
    ylabel('cells and trials')
    title([group, ' single trials'])
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
%                 StimID2(k + 3) = i;
                CellsTrialAveragedExemplars(:, k) = Mtrials(:, i, j);
                CellsTrialAveragedExemplars(:, k + 1) = Mtrials(:, i, (j + 1));
                CellsTrialAveragedExemplars(:, k + 2) = Mtrials(:, i, (j + 2));
%                 CellsTrialAveragedExemplars(:, k + 3) = Mtrials(:, i, (j + 3));
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

if plot_switch == 1
    figure
    imagesc(CellsTrialAveragedExemplars)
    xlabel('stimuli and trials')
    ylabel('cells')
    title([group, ' single trials (CellsTrialAveragedExemplars)'])
end
                                                                            % CellsTrialAveragedExemplars is cells x (stim * reps) and only has stimuli 1 and 10 (BA and DA)
                                                                            % CellsTrialAveragedExemplars is designed to be input for classification learner
stims = [1:30];                                                             % Set stims for to be trained on (should be all unless testing things)

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
%                 StimID3(k + 3) = i;
                CellsTrialAveragedAllStims(:, k) = Mtrials(:, i, j);
                CellsTrialAveragedAllStims(:, k + 1) = Mtrials(:, i, j + 1);
                CellsTrialAveragedAllStims(:, k + 2) = Mtrials(:, i, j + 2);
%                 CellsTrialAveragedAllStims(:, k + 3) = Mtrials(:, i, j + 3);
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

if plot_switch == 1
    if context_switch == 0
        figure
        imagesc(CellsTrialAveragedBADA)
        xlabel('stimuli and trials')
        ylabel('cells')
        title([group, ' single trials (CellsTrialAveragedBADA)'])
    elseif context_switch == 1
        figure
        imagesc(CellsTrialAveragedAllStims)
        xlabel('stimuli and trials')
        ylabel('cells')
        title([group, ' single trials (CellsTrialAveragedAllStims)'])
    end
end



%%% End Preprocessing
toc

if fit_model_switch == 1
    classificationLearner
    f = gcf;
    uiwait(gcf);
end
% Switch stop time to be phoneme only and not include vowel
load('OptSVM.mat');
if context_switch == 1
    yfit = OptSVM.predictFcn(CellsTrialAveragedAllStims);
elseif context_switch == 0
    yfit = ExpDataExemplarsLinDisc.predictFcn(CellsTrialAveragedBADA);
end
totalfitresults = sum(yfit == StimID3_Coerce) / length(StimID3_Coerce);

confusionmatrixallstims = zeros(30, 3);
for i = 1:length(yfit)
    curr_PredStimID = yfit(i);
    curr_TrueStimID = StimID3(i);
    if curr_PredStimID == 1
        confusionmatrixallstims(curr_TrueStimID, 1) = confusionmatrixallstims(curr_TrueStimID, 1) + 1;
    elseif curr_PredStimID == 10
        confusionmatrixallstims(curr_TrueStimID, 2) = confusionmatrixallstims(curr_TrueStimID, 2) + 1;
    end
end
for j = 1:30                                                                % or length(confusionmatrixallstims)
    confusionmatrixallstims(j, 3) = confusionmatrixallstims(j, 2)/(confusionmatrixallstims(j, 1) + confusionmatrixallstims(j, 2));
end

figure
plot(1:10, confusionmatrixallstims((1:10), 3), 'bo-');
if context_switch == 1
    hold on
    plot(1:10, confusionmatrixallstims((11:20), 3), 'go-');
    hold on
    plot(1:10, confusionmatrixallstims((21:30), 3), 'ro-');
end
xlabel('Ba-Da Spectrum');
ylabel('% of Stims Labeled Da');
title([group, ' Neurometric Curve (Trained Exemplars vs. Test 1-30)'])

toc