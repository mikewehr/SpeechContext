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
if ~isfile(Previous_data_file_name) % Logical on/off switch on generating new binned data (with different parameters) by including or removing tilde - SFM 7/13/21
    [saved_binned_data_file_name] = create_binned_data_from_raster_data(raster_file_directory_name, save_prefix_name, bin_width, sampling_interval, start_time, end_time);
end

%% set number and type of stimulus repetitions

load 'd:\lab\djmaus\Data\sfm\soundfile-iba-uda+WN80dB-full_duration--ISS-isi800ms-20reps.mat';
%label_names_to_use = 'stimuli.stimulus_description';

%recognize different stimuli
cd d:\lab\djmaus\Data\sfm\soundfile-iba-uda+WN80dB-full_duration--ISS-isi800ms-20reps_sourcefiles;
stimuli = dir('*.mat');
uniquestimuli = cell(30,1); %%%%% make an empty cell array the length of all the unique stimuli you have

% load('F:\Data\sfm\BinnedFiles\10ms_bins_5ms_sampled_170start_time_370end_time.mat');
% White Noise (WN) and Silent Sound (SS) are located in the stimlog here
% but need help adding them as labels since they do not have .mat files
% (can't use dir() method) - SFM 7/13/21

wavforms = cell(30,1);
for i = 1:length(stimuli)
   uniquestimuli{i} = stimuli(i).name;
   load(uniquestimuli{i})
   wavforms{i} = sample.sample;
end

BinnedDir = 'F:\Data\sfm\BinnedFiles'; %Directory from save_prefix_name where data is now in Binned form (minus the '\')
cd(BinnedDir);

%'uniquestimuli' contains the string name of each of the soundfiles presented, 'wavforms' are each soundfile converted into MATLAB 

for i = 1:length(uniquestimuli);
    presplit = split(uniquestimuli{i}, '_');
    presort = split(presplit{4}, '+');
    uniquelabels{i} = presort{1};
end
uniquelabels = uniquelabels';
%uniquelabels{31} = 'whitenoise'; % add in whitenoise and silent sound stimuli (add stimuli that don't have .mat files and need to be added manually) - SFM 7/19/21
%uniquestimuli{31} = 'whitenoise laser:0 duration:363.734 amplitude:80 ramp:0 next:800'; %these are auto generated in djmaus and don't have a saved unique waveform
%uniquelabels{32} = 'silentsound';
%uniquestimuli{32} = 'silentsound laser:0 duration:363.734 ramp:0 next:800'; 
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

binned_data_name = '10ms_bins_5ms_sampled_170start_time_370end_time.mat'; 'binned_data'; 'binned_site_info'; 'binned_labels';
load(binned_data_name);
binned_labels.full_name = uniquestimuli;
binned_labels.short_labels = uniquelabels;

%SFM 2/1/21 (still here on 7/13/21): whether giving the above labels as the list of unique stimuli
%delivered or the raw list of stimuli delivered, somehow in basic_DS
%'label_names_to_use' is transformed into a string of gibberish

num_sites = length(dir('F:\Data\sfm\RasterFiles\*.mat'));
the_labels = binned_labels.sourcefile;

%This function is optional but will set some useful parameters further in the analysis pipeline - SFM 7/13/21
for k = 1:100
    [inds_of_sites_with_at_least_k_repeats, min_num_repeats_all_sites num_repeats_matrix label_names_used] = find_sites_with_k_label_repetitions(the_labels, k);
    num_sites_with_k_repeats(k) = length(inds_of_sites_with_at_least_k_repeats);
end

%ds.site_to_use = find_sites_with_at_least_k_repeats_of_each_label(the_labels_to_use, num_cv_splits); %See error code in basic_DS Line ~590
%k = # of repetitions of each unique stimuli per cell - SFM 7/13/21

%% create a DataSource (DS) object

num_cv_splits = [5];
create_simultaneously_recorded_populations = 0; %Logical setting on whether to treat all cells as if recorded simultaneously, default is 0 (FALSE) - SFM 7/13/21
load_data_as_spike_counts = 0; %Logical setting if data should be loaded as absolute spike counts and not firing rates, default is 0 (FALSE/Firing Rate) - SFM 7/13/21

binned_format_file_name = 'F:\Data\sfm\BinnedFiles\10ms_bins_5ms_sampled_170start_time_370end_time.mat';
specific_label_name_to_use = binned_labels.sourcefile;

ds = basic_DS(binned_format_file_name, uniquestimuli, num_cv_splits);
[XTr_all_time_cv, YTr_all, XTe_all_time_cv, YTe_all] = get_data(ds);

%% creating a feature-processor (FP) object

% the_feature_preprocessors{1} = zscore_normalize_FP;
% X_normalized = preprocess_test_data(fp, X_data);
% [fp, XTr_normalized] = set_properties_with_training_data(fp, XTr);
% current_FP_info_to_save = get_current_info_to_save(fp);

%% creating a classifier (CL) object
XTr = XTr_all_time_cv;
XTe = XTe_all_time_cv;
YTr = YTr_all;
YTe = YTe_all;

cl = max_correlation_coefficient_CL;
cl = train(cl, XTr, YTr);
[predicted_labels, decision_values] = test(cl, XTe);

%% creating a cross-validator (CV) object

the_cross_validator.num_resample_runs = 5;
cv = standard_resample_CV(ds, cl);
DECODING_RESULTS = run_cv_decoding(cv);
%set how many times the outer 'resample' loop is run, generally we use more
%than 2 resample runs which will give more accurate results but just
%throwing 2 in for now

%% running decoding analysis

decoding_results = the_cross_validator.run_cv_decoding;
save_file_name = 'Initial Decoding Results';
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
