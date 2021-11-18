% load synthetic speech context outfiles and extract spikes into a matrix
% so we can do some sanity checking

%the outfiles are on D:
clear
tic
cd('/Users/sammehan/Documents/Wehr Lab/SpeechContext2021/Synthetic Outfiles')
group = 'Group6';

cd(group)
d = dir('outPSTH*.mat');

if ~exist('GroupDataTable.mat', 'file')
    for i = 1:length(d)
        fprintf('\n%d/%d', i, length(d))
        outfilename = sprintf('outPSTH_synth_ch%dc%d.mat', i, i);
        out = load(outfilename);
        data(i).M1OFF = out.out.M1OFF;
        data(i).mM1OFF = out.out.mM1OFF;
    end
    save('GroupDataTable', 'data');
    nreps = max(out.out.nreps(:));
else
    load('GroupDataTable.mat');
    nreps = 40;
end

start = 190;
stop = 350;
% trial-averaged
for j = 1:length(data)
    mM1OFF = data(j).mM1OFF(:,2,2,1);
    for k = 1:length(mM1OFF)
        spiketimes = mM1OFF(k).spiketimes;
        spikecount = length(find(spiketimes >= start & spiketimes <= stop));
        sc(k) = spikecount;
    end
    scsorted = sc([1 3 4 5 6 7 8 9 10 2 11 13 14 15 16 17 18 19 20 12 21 23 24 25 26 27 28 29 30 22]);
    cellsbystim_datatable(j,:) = scsorted;
end

figure
imagesc(cellsbystim_datatable(:, 1:10))
colormap jet
xlabel('stimulus')
ylabel('cell')
title([group, 'trial-averaged'])

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

%%%
% Single trials

TotalTrialsByStim = [];
for j = 1:length(data)
    M1OFF = data(j).M1OFF(:,2,2,:);
    for k = 1:size(M1OFF, 1)
        for rep = 1:size(M1OFF, 4)
            spiketimes = M1OFF(k, 1, 1, rep).spiketimes;
            spikecount = length(find(spiketimes >= start & spiketimes <= stop));
            sc(k, rep) = spikecount;
        end
    end
    scsorted = sc([1 3 4 5 6 7 8 9 10 2 11 13 14 15 16 17 18 19 20 12 21 23 24 25 26 27 28 29 30 22], :);
    Mtrials(j,:,:) = scsorted;
    % Mtrials is cells x stimulus x rep
    TotalTrialsByStim = [TotalTrialsByStim scsorted];
end

TotalTrialsByStim = TotalTrialsByStim(1:10, :)';

figure
imagesc(TotalTrialsByStim)
xlabel('stimulus')
ylabel('cells and trials')
title([group, 'single trials'])

clear response CellsTrialAveragedExemplars
CellsTrialAveragedExemplars = [];
k = 0;
for i = [1 10] % BA and DA only
    for j = 1:nreps
        k = k + 1;
        StimID2(k) = i;
        CellsTrialAveragedExemplars(:, k) = Mtrials(:, i, j);
    end
end
figure
imagesc(CellsTrialAveragedExemplars)
xlabel('stimuli and trials')
ylabel('cells')
title([group, 'single trials (CellsTrialAveragedExemplars)'])

% CellsTrialAveragedExemplars is cells x (stim * reps) and only has stimuli 1 and 10 (BA and DA)
% CellsTrialAveragedExemplars is designed to be input for classification learner

clear response CellsTrialAveragedBADA
CellsTrialAveragedBADA = [];
k = 0;
for i = [1:10] % All BA-DA
    for j = 1:nreps
        k = k + 1;
        StimID3(k) = i;
        CellsTrialAveragedBADA(:, k) = Mtrials(:, i, j);
    end
end
figure
imagesc(CellsTrialAveragedBADA)
xlabel('stimuli and trials')
ylabel('cells')
title([group, 'single trials (CellsTrialAveragedBADA)'])
% CellsTrialAveragedBADA is cells x (stim * reps)
% CellsTrialAveragedBADA is designed to be input for classification learner

coerce_switch = 0;
if coerce_switch == 1
    for i = 1:length(StimID3)
        if strcmp(StimID3{i}, 'soundfile_iba-uda_sourcefile_ba-da1+3.5oct.wav_1_80dB_0.4s.mat') || strcmp(StimID3{i}, 'soundfile_iba-uda_sourcefile_ba-da10+3.5oct.wav_10_80dB_0.4s.mat')
            StimID3(k) = StimID3(k);
        elseif strcmp(StimID3{i}, 'soundfile_iba-uda_sourcefile_ba-da2+3.5oct.wav_2_80dB_0.4s.mat') || strcmp(StimID3{i}, 'soundfile_iba-uda_sourcefile_ba-da3+3.5oct.wav_3_80dB_0.4s.mat') || strcmp(StimID3{i}, 'soundfile_iba-uda_sourcefile_ba-da4+3.5oct.wav_4_80dB_0.4s.mat') || strcmp(StimID3{i}, 'soundfile_iba-uda_sourcefile_ba-da5+3.5oct.wav_5_80dB_0.4s.mat')
            StimID3(k) = 'soundfile_iba-uda_sourcefile_ba-da1+3.5oct.wav_1_80dB_0.4s.mat';
        elseif strcmp(StimID3{i}, 'soundfile_iba-uda_sourcefile_ba-da6+3.5oct.wav_6_80dB_0.4s.mat') || strcmp(StimID3{i}, 'soundfile_iba-uda_sourcefile_ba-da7+3.5oct.wav_7_80dB_0.4s.mat') || strcmp(StimID3{i}, 'soundfile_iba-uda_sourcefile_ba-da8+3.5oct.wav_8_80dB_0.4s.mat') || strcmp(StimID3{i}, 'soundfile_iba-uda_sourcefile_ba-da9+3.5oct.wav_9_80dB_0.4s.mat')
            StimID3(k) = 'soundfile_iba-uda_sourcefile_ba-da10+3.5oct.wav_10_80dB_0.4s.mat';
        else
        end
    end
end

pause

load('Group6ExemplarsLinDisc.mat');
yfit = Group6ExemplarsLinDisc.predictFcn(CellsTrialAveragedBADA);
totalfitresults = sum(yfit == StimID3') / length(StimID3);

confusionmatrixallstims = zeros(30, 3);
for i = 1:length(yfit)
    presplit1 = strsplit(yfit{i}, '_');
    curr_PredStimID = str2double(presplit1{5});
    presplit2 = strsplit(StimID3{i}, '_');
    curr_TrueStimID = str2double(presplit2{5});
    if curr_PredStimID == 1
        if curr_TrueStimID >= 1 && curr_TrueStimID <= 5
            confusionmatrixallstims(curr_TrueStimID, 1) = confusionmatrixallstims(curr_TrueStimID, 1) + 1;
        else
            confusionmatrixallstims(curr_TrueStimID, 2) = confusionmatrixallstims(curr_TrueStimID, 2) + 1;
        end
    elseif curr_PredStimID == 10
        if curr_TrueStimID >= 6 && curr_TrueStimID <= 10
            confusionmatrixallstims(curr_TrueStimID, 1) = confusionmatrixallstims(curr_TrueStimID, 1) + 1;
        else
            confusionmatrixallstims(curr_TrueStimID, 2) = confusionmatrixallstims(curr_TrueStimID, 2) + 1;
        end
    end
end

for j = 1:length(confusionmatrixallstims)
    confusionmatrixallstims(j, 3) = confusionmatrixallstims(j, 2)/(confusionmatrixallstims(j, 1) + confusionmatrixallstims(j, 2));
end

figure
plot(1:10, confusionmatrixallstims((1:10), 3), 'bo-');
xlabel('Ba-Da Spectrum');
ylabel('% of Stims Labeled Da');
title([group, ' Neurometric Curve (Trained Exemplars vs. Test 1-10)'])


% PC = [sum(yfit(1:40))/1, ...
% sum(yfit(41:80))/1, ...
% sum(yfit(81:120))/1, ...
% sum(yfit(121:160))/1, ...
% sum(yfit(161:200))/1, ...
% sum(yfit(201:240))/1, ...
% sum(yfit(241:280))/1, ...
% sum(yfit(281:320))/1, ...
% sum(yfit(321:360))/1, ...
% sum(yfit(361:400))/1]


toc