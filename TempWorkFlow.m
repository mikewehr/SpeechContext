%% Modified Workflow (Working Working Workflow)
clear all
%%  Preprocessing of Data

% DataDir = 'F:\Data\sfm\RasterFiles';
% cd(DataDir)
% convert_outfile_to_raster_format_sfm

BinnedDir = 'F:\Data\sfm\BinnedFiles';
cd(BinnedDir);

save_prefix_name = 'F:\Data\sfm\BinnedFiles\TestRun';
bin_width = 10; 
step_size = 5;  
start_time = 170;
end_time = 370;
 
Previous_data_file_name = strcat(save_prefix_name,'_',num2str(bin_width),'ms_bins_',num2str(step_size),'ms_sampled_',num2str(start_time),'start_time_',num2str(end_time),'end_time.mat');
if ~isfile(Previous_data_file_name) % Logical on/off switch on generating new binned data (with different parameters) by including or removing tilde - SFM 7/13/21
    [saved_binned_data_file_name] = create_binned_data_from_raster_data(raster_data_directory_name, save_prefix_name, bin_width, step_size, start_time, end_time);
    binned_data_file_name = saved_binned_data_file_name
else
    binned_data_file_name = 'TestRun_10ms_bins_5ms_sampled_170start_time_370end_time.mat' % Enter Binned Data name here if already generated - SFM 7/27/21
end                     % 'Binned_Zhang_Desimone_7object_data_150ms_bins_50ms_sampled.mat' example dataset binned

%%  Optional Utility Function

load(binned_data_file_name);  % load the binned data

% for i = 0:100
%     inds_of_sites_with_at_least_k_repeats = find_sites_with_k_label_repetitions(binned_labels.sourcefile, i);
%     num_sites_with_k_repeats(i + 1) = length(inds_of_sites_with_at_least_k_repeats);
% end

%%  6.  Create DS

load(binned_data_file_name);
specific_binned_labels_names = binned_labels.sourcefile; %.stimulus_ID for example data - SFM 7/28/21
num_cv_splits = 20; 

ds = basic_DS(binned_data_file_name, specific_binned_labels_names, num_cv_splits);
[XTr, YTr, XTe, YTe] = get_data(ds); 

%%   7.  Create FP

fp = zscore_normalize_FP;
%[fp, XTr_norm] = set_properties_with_training_data(fp, XTr, num_cv_splits); % Need to solve tilde problem - SFM 7/28/21
% X_norm = preprocess_test_data(fp, XTe)

%%  8.  Create CL 

cl = max_correlation_coefficient_CL;

cl = train(cl, XTr, YTr, num_cv_splits); % We will see if this is 'right' - SFM 7/28/21
[predicted_labels, decision_values] = test(cl, XTe); % Still needs work converting to matrices/arrays - SFM 7/28/21

%%  9.  CV

the_cross_validator = standard_resample_CV(ds, cl, fp);  

the_cross_validator.num_resample_runs = 20;  % usually more than 2 resample runs are used to get more accurate results, but to save time we are using a small number here

%%  10.  Get Data!   

DECODING_RESULTS = the_cross_validator.run_cv_decoding; 

%%  11.  Save results

% save the results
save_file_name = 'Initial Output V1';
save(save_file_name, 'DECODING_RESULTS'); 

%%  12.  Plotting

% which results should be plotted (only have one result to plot here)
result_names{1} = save_file_name;

% create an object to plot the results
plot_obj = plot_standard_results_object(result_names);

% put a line at the time when the stimulus was shown
plot_obj.significant_event_times = 0;   

% optional argument, can plot different types of results
%plot_obj.result_type_to_plot = 2;  % for example, setting this to 2 plots the normalized rank results

plot_obj.plot_results;   % actually plot the results

%%  13.  Plot the TCT matrix

plot_obj = plot_standard_results_TCT_object(save_file_name);

plot_obj.significant_event_times = 0;   % the time when the stimulus was shown

% optional parameters when displaying the TCT movie
%plot_obj.movie_time_period_titles.title_start_times = [-500 0];
%plot_obj.movie_time_period_titles.title_names = {'Fixation Period', 'Stimulus Period'}

plot_obj.plot_results;  % plot the TCT matrix and a movie showing if information is coded by a dynamic population code

%%







