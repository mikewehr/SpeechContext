% Use this quick function to run PlotSpeechContext and generate outfiles in
% each of the subdirectories of a given mouse or session
% Make sure ant outfiles from individualized sessions are tucked away in a
% folder within each directory or they will be overwritten/not work

masterdir = 'D:\lab\djmaus\Data\sfm\2020-12-11_12-00-33_mouse-0095'; % Set master directory where kilosort was run - SFM 8/10/21
cd (masterdir)
load('dirs.mat')
for i = 1:length(dirs)
    cd (dirs{i})
    PlotSpeechContext
    i
end
