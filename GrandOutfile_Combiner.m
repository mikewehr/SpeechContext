clear all;
masterdir = "D:\lab\djmaus\Data\sfm\2021-01-18_11-55-16_mouse-0295" %set master directory
targetdir = "F:\Data\sfm\0295"

cd(masterdir)
load("dirs.mat")
outfilecelllist = dir('outPSTH*.mat')
    for i = 1:length(outfilecelllist)
        for j = 1:24 %1:length(dirs) %or 162 (total outfile number per mouse)?
%             k = j-12;
            cd (dirs{j}) %or 1:12 and 13:24 (number of dirs that may need splitting)?
%             tempsplit = strsplit(outfilecelllist(i).name, 'ch')
%             tempsplit = strsplit(tempsplit{2}), 
%             load('outPSTH_ch%dc%d.mat', Out.tetrode, Out.cell) %make unique values so only the same outfile is selected each pass
            singleoutfilelist{j} = strcat(dirs{j},'\', outfilecelllist(i).name); 
        end

        Outfile_Combiner(singleoutfilelist, targetdir)
        %save(combinedoutfilename, 'out', '-v7.3') %override line 426 in Outfile_Combiner?
        i
    end
 fprintf("Outfiles for this selection have been combined and saved to")