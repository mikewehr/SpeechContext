% The Big Workflow

%% declare your variables
raster_file_directory_name = 'D:\lab\djmaus\Data\sfm\2021-01-18_14-21-23_mouse-0098-NDT\raster_files';
save_prefix_name = '2021-01-18_14-21-23_mouse-0098';
bin_width = 500; %in ms
sampling_interval = 50; %in ms
start_time = [];
end_time = [];

%%
[saved_binned_data_file_name] = create_binned_data_from_raster_data(raster_file_directory_name, save_prefix_name, bin_width, sampling_interval, start_time, end_time);
