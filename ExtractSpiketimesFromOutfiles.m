

tic
cd('/Users/sammehan/Documents/Wehr Lab/SpeechContext2021/Synthetic Outfiles')
d = dir('outPSTH*.mat');

for i = 1:length(d)
    fprintf('\n%d/%d', i, length(d))
    outfilename = sprintf('outPSTH_synth_ch%dc%d.mat', i, i);
    out = load(outfilename);
    data(i).M1OFF = out.out.M1OFF;
    data(i).mM1OFF = out.out.mM1OFF;
end

save('ExpDataTable', 'data');
toc
