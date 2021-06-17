masterdir = "D:\lab\djmaus\Data\sfm\2021-01-18_11-55-16_mouse-0295" %set master directory
%Outfiler_Combiner.experiment_type = "SpeechContext" or CreateNewOutfile.case = "SpeechContext"

cd(masterdir)
load("dirs.mat")
outfilecelllist = dir('outPSTH*.mat')
    for i = 1:outfilecellist{}
        for j = 1:length(dirs) %or 162 (total outfile number per mouse)?
            cd (dirs{j}) %or 1:12 and 13:24 (number of dirs that may need splitting)?
            load('outPSTH_ch%dc%d.mat', Out.tetrode, Out.cell) %make unique values so only the same outfile is selected each pass
            singleoutfilelist{j} = 'outPSTH_ch%dc%d.mat', Out.tetrode, Out.cell,
        end

        Outfile_Combiner(singleoutfilelist)
        %save(combinedoutfilename, 'out', '-v7.3') %override line 426 in Outfile_Combiner?
        i
    end
 fprintf("Outfiles for this selection have been combined and saved to")