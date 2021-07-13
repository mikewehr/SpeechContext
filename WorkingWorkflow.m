% The Big Workflow
clear all
%% convert out files to raster data:
DataDir = 'F:\Data\sfm\RasterFiles';
cd(DataDir)
%convert_outfile_to_raster_format_sfm.m

%% declare your variables:
raster_file_directory_name = 'F:\Data\sfm\RasterFiles\'; %Directory where rasterized OUTfiles are
save_prefix_name = 'F:\Data\sfm\BinnedFiles\'; %Directory to send new binned data too
bin_width = 10; %in ms
sampling_interval = bin_width/2; %in ms
start_time = 170; %ms
end_time = 370; %ms
% if start_time and end_time are not declared NDT will generate values (we will never do this - SFM 7/12/21)
%% Creat the binned data:
Previous_data_file_name = strcat(save_prefix_name,num2str(bin_width),'ms_bins_',num2str(sampling_interval),'ms_sampled_',num2str(start_time),'start_time_',num2str(end_time),'end_time.mat');
if ~isfile(Previous_data_file_name)
    [saved_binned_data_file_name] = create_binned_data_from_raster_data(raster_file_directory_name, save_prefix_name, bin_width, sampling_interval, start_time, end_time);
end

%% set number and type of stimulus repetitions

load 'd:\lab\djmaus\Data\sfm\soundfile-iba-uda+WN80dB-full_duration--ISS-isi800ms-20reps.mat';
%label_names_to_use = 'stimuli.stimulus_description';

%recognize different stimuli
cd d:\lab\djmaus\Data\sfm\soundfile-iba-uda+WN80dB-full_duration--ISS-isi800ms-20reps_sourcefiles;
stimuli = dir('*.mat');
uniquestimuli = cell(30,1); %%%%% make an empty cell array the length of all the unique stimuli you have
%%%% also, you'll need to talk to Mike, see where the SS and WN are
%%%% located, and then add them to this process
wavforms = cell(30,1);
for i = 1:length(stimuli)
   uniquestimuli{i} = stimuli(i).name;
   load(uniquestimuli{i})
   wavforms{i} = sample.sample;
end
BinnedDir = 'F:\Data\sfm\BinnedFiles' %Directory where data is now in Binned form
cd(BinnedDir);

%'uniquestimuli' contains the string name of each of the soundfiles presented, 'wavforms' are each soundfile converted into MATLAB 

for i = 1:length(uniquestimuli);
    presplit = split(uniquestimuli{i}, '_');
    presort = split(presplit{4}, '+');
    uniquelabels{i} = presort{1};
end
clear presort
clear presplit

% We rewrote what is below, to do at the same time of finding the waveforms
% too
% descriptions = cell(32,1); %%%%% make an empty cell array the length of all the unique stimuli you have
% for i = 1:length(stimuli)
%     descriptions{i} = stimuli(i).stimulus_description;
% end
% uniquestimuli = unique(descriptions);
% binned_labels = 'stimuli.stimulus_description';

%This appears to only be used in the function below to set up k repeats of each stimulus per neuron
binned_labels.full_name = uniquestimuli;
binned_labels.labels_to_use = uniquelabels;

%SFM 2/1/21 whether giving the above labels as the list of unique stimuli
%delivered or the raw list of stimuli delivered, somehow in basic_DS
%'label_names_to_use' is transformed into a string of gibberish

num_sites = length(dir('F:\Data\sfm\RasterFiles\*.mat'));
the_labels = binned_labels.full_name;

for k = 0:100
    [inds_of_sites_with_at_least_k_repeats, min_num_repeats_all_sites num_repeats_matrix label_names_used] = find_sites_with_k_label_repetitions(the_labels, k);
    num_sites_with_k_repeats(k) = length(inds_of_sites_with_at_least_k_repeats);
end

%ds.site_to_use = find_sites_with_at_least_k_repeats_of_each_label(the_labels_to_use, num_cv_splits); %See error code in basic_DS Line 590
%k = # of repititions of each unique stimuli (20 for each unique wav file * 32 unique wavs 

%% create a DataSource (DS) object

num_cv_splits = [20];
create_simultaneously_recorded_populations = 0; %Logical setting on whether to treat all cells as if recorded simultaneously, default is 0 (FALSE) - SFM 7/13/21
load_data_as_spike_counts = 0; %Logical setting if data should be loaded as absolute spike counts and not firing rates, default is 0 (FALSE/Firing Rate) - SFM 7/13/21

binned_format_file_name = 'F:\Data\sfm\BinnedFiles\10ms_bins_5ms_sampled_170start_time_370end_time.mat';
binned_data_name = '10ms_bins_5ms_sampled_170start_time_370end_time.mat', 'binned_data', 'binned_site_info', 'binned_labels';
specific_label_name_to_use = uniquelabels;

ds = basic_DS(binned_format_file_name, specific_label_name_to_use, num_cv_splits);

%% creating a feature-processor (FP) object
get_data(ds)
the_properties = get_DS_properties(ds)

the_feature_preprocessors{1} = zscore_normalize_FP;
%% creating a classifier (CL) object

the_classifier = max_correlation_coefficient_CL;

%% creating a cross-validator (CV) object

the_cross_validator = standard_resample_CV(ds, the_classifier, the_feature_preprocessors);

%set how many times the outer 'resample' loop is run, generally we use more
%than 2 resample runs which will give more accurate results but just
%throwing 2 in for now

the_cross_validator.num_resample_runs = 2;

%% running decoding analysis

decoding_results = the_cross_validator.run_cv_decoding;
save_file_name = '2021-01-18_14-21-23_mouse-0098-decoding-results';
save(save_file_name, 'decoding-results');

%% plotting results

result_names{1} = save_file_name;
plot_obj = plot_standard_results_object(result_names);
plot_obj.significant_events_times = 0;    %plot line when stimulus occured
plot_obj.plot_results;

%% plotting temporal cross training decoding accuracies

plot_obj = plot_standard_results_TCT_object(save_file_name);
plot_obj.significant_event_times = 0;
plot_obj.plot_results;
