clear all;
masterdir = "D:\lab\djmaus\Data\sfm\2021-01-18_11-55-16_mouse-0295"; %set master directory
targetdir = "F:\Data\sfm";

cd(masterdir)
load("dirs.mat")
outfilecelllist = dir('outPSTH*.mat');
for i = 1:length(outfilecelllist)
    k = 0;
    for j = 1:24 %1:length(dirs) %or 162 (total outfile number per mouse)?
        %             k = j-12;
        cd (dirs{j}) %or 1:12 and 13:24 (number of dirs that may need splitting)
        load(string(outfilecelllist(i).name));
        if ~isempty(out.spiketimes) == 1
            k = k+1;
            singleoutfilelist{k} = strcat(dirs{j},'\', outfilecelllist(i).name); % I think there is a way to do this faster (set up outfiles so that the entire thing doesn't have to be loaded) but not sure, this does work though - SFM 7/14/21
        end  %Maybe use append() here instead? - SFM 7/14/21
        clear out
    end
        
        Outfile_Combiner(singleoutfilelist, targetdir)
        i
        clear singleoutfilelist
end

fprintf("Outfiles for this selection have been combined and saved to")