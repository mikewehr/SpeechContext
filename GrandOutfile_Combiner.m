clear all;
masterdir = "D:\lab\djmaus\Data\sfm\2021-01-18_11-55-16_mouse-0295"; %set master directory
targetdir = "F:\Data\sfm\Finalized Outfiles\0295";

cd(masterdir)
load("dirs.mat")
%load('D:\lab\djmaus\Data\sfm\GrandKilosort0095CombinedOutfiles\GrandKilosortOutfilesFullMouse\outPSTH_combined_ch5c335.mat', 'out');
%dirs = out.dirlist %Use these two lines to pick and choose dirs to combine from in case some are missing triggers/otherwise bad - SFM 7/16/21

outfilecelllist = dir('outPSTH*.mat');
for i = 62:length(outfilecelllist)
    k = 0;
    for j = 1:length(dirs) %1:total outfile number per mouse
        cd (dirs{j}) %large outfiles may need to be added in parts or matlab will run out of RAM
        load(string(outfilecelllist(i).name));
        if ~isempty(out.spiketimes) == 1
            k = k + 1;
            singleoutfilelist{k} = strcat(dirs{j},'\', outfilecelllist(i).name); % consider saving spiketimes as a logical when generating files for speed - SFM 7/15/21
        else
        end  %also could add this similar code to PlotSpeechContext for generating them in the first place for speed - SFM 7/15/21
        clear out
    end
        
        Outfile_Combiner(singleoutfilelist, targetdir);
        i
        clear singleoutfilelist
end

fprintf("Outfiles for this selection have been combined and saved to")