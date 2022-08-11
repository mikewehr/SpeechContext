d = dir('outPSTH*.mat');
temp_string = strsplit(pwd, '\');
mouseID = temp_string{5};
for i = 1:length(d)
    fprintf('\n%d/%d', i, length(d))
    outfile_list{i} = d(i).name;
    out = load(d(i).name);
    data(i).M1OFF = out.out.M1OFF;
    data(i).mM1OFF = out.out.mM1OFF;
end
for i = 1:length(data)
    data(i).M1OFF = data(i).M1OFF([1 3 4 5 6 7 8 9 10 2 11 13 14 15 16 17 18 19 20 12 21 23 24 25 26 27 28 29 30 22], :, :, :);
    data(i).mM1OFF = data(i).mM1OFF([1 3 4 5 6 7 8 9 10 2 11 13 14 15 16 17 18 19 20 12 21 23 24 25 26 27 28 29 30 22], :, :);
end
nreps = max(out.out.nreps(:));
savename = strcat('ExpDataTable-', mouseID, '-v1');
save(savename, 'data', 'mouseID', 'outfile_list');
