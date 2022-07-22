

if ~exist('ExpDataTable.mat', 'file')
    d = dir('outPSTH*.mat');
    for i = 1:length(d)
        fprintf('\n%d/%d', i, length(d))
        temp_str = strsplit(d(i).name, '_');
        outfilename = strcat(temp_str{1}, '_', temp_str{3});
        outfile_list{i} = outfilename;
        out = load(d(1).name);
        data(i).M1OFF = out.out.M1OFF;
        data(i).mM1OFF = out.out.mM1OFF;
    end
    
    nreps = max(out.out.nreps(:));
end

for i = 1:length(data)
    data(i).M1OFF = data(i).M1OFF([1 3 4 5 6 7 8 9 10 2 11 13 14 15 16 17 18 19 20 12 21 23 24 25 26 27 28 29 30 22], :, :, :);
    data(i).mM1OFF = data(i).mM1OFF([1 3 4 5 6 7 8 9 10 2 11 13 14 15 16 17 18 19 20 12 21 23 24 25 26 27 28 29 30 22], :, :);
end

temp_string = pwd;
temp_string2 = strsplit(temp_string, '\');
mouseID = temp_string2{end};
savename = strcat('ExpDataTable-', mouseID);
save(savename, 'data', 'outfile_list', 'mouseID');