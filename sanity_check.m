% load synthetic speech context outfiles and extract spikes into a matrix
% so we can do some sanity checking

%the outfiles are on D:
cd('/Volumes/wehrrig2b.uoregon.edu/lab/djmaus/Data/sfm/synthetic_SpeechContext_data')
group='Group11';

cd(group)
d=dir('outPSTH*.mat');
for i=1:length(d)
    fprintf('\n%d/%d', i, length(d))
    outfilename=sprintf('outPSTH_synth_ch%dc%d.mat', i, i);
    out=load(outfilename);
    data(i).M1OFF=out.out.M1OFF;
    data(i).mM1OFF=out.out.mM1OFF;
end

nreps=max(out.out.nreps(:))

start=200;
stop=350;
% trial-averaged
for j=1:length(data)
    mM1OFF = data(j).mM1OFF(:,2,2,1);
    for k=1:length(mM1OFF)
        spiketimes= mM1OFF(k).spiketimes;
        spikecount=length( find(spiketimes>=start & spiketimes<=start));
        sc(k)=spikecount;
    end
    scsorted=sc([1  3 4 5 6 7 8 9 10 2 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30]);
    M(j,:)=scsorted;
end
figure
imagesc(M)
colormap jet
xlabel('stimulus')
ylabel('cell')
title([group, 'trial-averaged'])



figure
 plot(M(1,1:30), M(25,1:30), 'o')
ax=axis;
xlabel('cell 1')
ylabel('cell 25')
figure
for i=1:size(M, 2)
    text(M(1,i), M(25, i),int2str(i))
end
xlabel('cell 1')
ylabel('cell 25')
axis(ax)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% single trials
Mflat=[];
for j=1:length(data)
    M1OFF = data(j).M1OFF(:,2,2,:);
    for k=1:size(M1OFF, 1)
        for rep=1:size(M1OFF, 4)
            spiketimes= M1OFF(k, 1, 1, rep).spiketimes;
            spikecount=length( find(spiketimes>=start & spiketimes<=start));
            sc(k, rep)=spikecount;
        end
    end
            scsorted=sc([1  3 4 5 6 7 8 9 10 2 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30], :);
        Mtrials(j,:,:)=scsorted;
        %Mtrials is cells x stimulus x rep
        Mflat=[Mflat scsorted];

end
figure
imagesc(Mflat')
xlabel('stimulus')
ylabel('cells and trials')
title([group, 'single trials'])


clear response Mflat2
k=0;
for i=[1 10] %stimulus 1 and 10
for j=1: nreps
        k=k+1;
        response2(k)=i
        Mflat2(:, k)= Mtrials(:, i, j);
    end
end
figure
imagesc(Mflat2)
xlabel('stimuli and trials')
ylabel('cells')
title([group, 'single trials (Mflat2)'])

% Mflat2 is cells x (stim*reps) and only has stimuli 1 and 10
%Mflat 2 is designed to be input for classificationlearner


clear response Mflat3
k=0;
for i=[1:10] %all stimuli
for j=1: nreps
        k=k+1;
        response3(k)=i
        Mflat3(:, k)= Mtrials(:, i, j);
    end
end
figure
imagesc(Mflat3)
xlabel('stimuli and trials')
ylabel('cells')
title([group, 'single trials (Mflat3)'])

% Mflat2 is cells x (stim*reps)
%Mflat 2 is designed to be input for classificationlearner

yfit = trainedModel.predictFcn(Mflat3);
sum(yfit==response3')/length(response3)

PC=[sum(yfit(1:40))/1, ...
sum(yfit(41:80))/1, ...
sum(yfit(81:120))/1, ...
sum(yfit(121:160))/1, ...
sum(yfit(161:200))/1, ...
sum(yfit(201:240))/1, ...
sum(yfit(241:280))/1, ...
sum(yfit(281:320))/1, ...
sum(yfit(321:360))/1, ...
sum(yfit(361:400))/1]













