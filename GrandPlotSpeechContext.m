% Use this quick function to run PlotSpeechContext and generate outfiles in
% each of the subdirectories of a given mouse or session
% Make sure ant outfiles from individualized sessions are tucked away in a
% folder within each directory or they will be overwritten/not work

masterdir = 'D:\lab\djmaus\Data\sfm\2021-01-18_11-55-16_mouse-0295'; % set master directory where kilosort was run
cd (masterdir)
load('dirs.mat')
for i = 11, 12, 17, 19:24,           %REPROCESS 11, 12, 17
    cd (dirs{i})
    PlotSpeechContext
    i
end
