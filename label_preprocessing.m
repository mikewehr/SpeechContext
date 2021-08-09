% Encoding of Broad Features
% This may not be necessary if NDT cooperates - SFM 8/5/21

binneddir = 'F:\Data\sfm\BinnedFiles'; % Enter binned data directory here - SFM 8/3/21
cd(binneddir)

binneddata = [];    %Enter binned data to be labeled here - SFM 8/3/21
load(binneddata)
for j = 1:length(binned_labels.sourcefile)%
    for i = 1:length(binned_labels.sourcefile) %may change source of stimlogs - SFM 8/3/21
        firstsort = strsplit(binned_labels.sourcefile{1,j}{1,i}, '_');
        secondsort = strsplit(firstsort{4}, '+');
        thirdsort = strsplit(secondsort{1}, 'a');
        if str2num(thirdsort{3}) <= 5
            binned_labels.sourcefile{1,j}{1,i}.phonemeidentity = 'ba';
        else
            binned_labels.sourcefile{1,j}{1,i}.phonemeidentity = 'da';
        end

        if strcmp(thirdsort{1}, 'b')
            binned_labels.sourcefile{1,j}{1,i}.contextidentity = 'none';
        elseif strcmp(thirdsort{1}, 'ub')
            binned_labels.sourcefile{1,j}{1,i}.contextidentity = 'U';
        else strcmp(thirdsort{1}, 'ib')
            binned_labels.sourcefile{1,j}{1,i}.contextidentity = 'I';
        end
        clear firstsort secondsort thirdsort;
    end
end