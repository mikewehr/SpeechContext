%% Modified Workflow (Working Working Workflow)

%ProcessSoundFile_single or PlotSpeechContext to generate OUTfiles
%GrandOutfile_Combiner
%OutDir = 'D:\lab\djmaus\Data\sfm\';
%cd(DataDir)
%convert_outfile_to_raster_format_sfm

%%

tic;
clear all

%%  Preprocessing of Data

RasterDir = 'F:\Data\sfm\Synthetic Test Data\Group 5';
% cd(RasterDir)
% convert_outfile_to_raster_format_sfm

BinnedDir = 'F:\Data\sfm\BinnedFiles';
cd(BinnedDir);

save_prefix_name = 'F:\Data\sfm\BinnedFiles\SynthGroup5';
bin_width = 20; 
step_size = 10;
start_time = 170;
end_time = 370;
 
Previous_data_file_name = strcat(save_prefix_name,'_',num2str(bin_width),'ms_bins_',num2str(step_size),'ms_sampled_',num2str(start_time),'start_time_',num2str(end_time),'end_time.mat');
if ~isfile(Previous_data_file_name) % Logical on/off switch on generating new binned data (with different parameters) by including or removing tilde - SFM 7/13/21
    [saved_binned_data_file_name] = create_binned_data_from_raster_data(RasterDir, save_prefix_name, bin_width, step_size, start_time, end_time);
    binned_data_file_name = saved_binned_data_file_name
else
    binned_data_file_name = Previous_data_file_name 
end                     % 'Binned_Zhang_Desimone_7object_data_150ms_bins_50ms_sampled.mat' example dataset binned - SFM 7/28/21

%% Encoding of Broad Features

% binneddir = 'F:\Data\sfm\BinnedFiles'; % Enter binned data directory here - SFM 8/3/21
% cd(binneddir)
% 
% binneddata = [];%Enter binned data to be labeled here - SFM 8/3/21
% load(binneddata)
% for j = 1:length(binned_labels.sourcefile)%
%     for i = 1:length(binned_labels.sourcefile) %may change source of stimlogs - SFM 8/3/21
%         firstsort = strsplit(binned_labels.sourcefile{1,j}{1,i}, '_');
%         secondsort = strsplit(firstsort{4}, '+');
%         thirdsort = strsplit(secondsort{1}, 'a');
%         if str2num(thirdsort{3}) <= 5
%             binned_labels.sourcefile{1,j}{1,i}.phonemeidentity = 'ba';
%         else
%             binned_labels.sourcefile{1,j}{1,i}.phonemeidentity = 'da';
%         end
% 
%         if strcmp(thirdsort{1}, 'b')
%             binned_labels.sourcefile{1,j}{1,i}.contextidentity = 'none';
%         elseif strcmp(thirdsort{1}, 'ub')
%             binned_labels.sourcefile{1,j}{1,i}.contextidentity = 'U';
%         else strcmp(thirdsort{1}, 'ib')
%             binned_labels.sourcefile{1,j}{1,i}.contextidentity = 'I';
%         end
%         clear firstsort secondsort thirdsort;
%     end
% end

%%  Optional Utility Function

load(binned_data_file_name);

% for k = 1:100
%     inds_of_sites_with_at_least_k_repeats = find_sites_with_k_label_repetitions(binned_labels.sourcefile, k);
%     num_sites_with_k_repeats(k) = length(inds_of_sites_with_at_least_k_repeats); 
% end
% toc

%%    Create DS

specific_binned_label_names = binned_labels.sourcefile; %.stimulus_ID for example data - SFM 7/28/21
num_cv_splits = 20; 

the_training_label_names = {'soundfile_iba-uda_sourcefile_ba-da1+3.5oct.wav_1_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_ba-da10+3.5oct.wav_10_80dB_0.4s.mat'};
%{'soundfile_iba-uda_sourcefile_ba-da1+3.5oct.wav_1_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_ba-da2+3.5oct.wav_2_80dB_0.4s.mat';
%     'soundfile_iba-uda_sourcefile_ba-da3+3.5oct.wav_3_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_ba-da4+3.5oct.wav_4_80dB_0.4s.mat';
%     'soundfile_iba-uda_sourcefile_ba-da5+3.5oct.wav_5_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_iba-da1+3.5oct.wav_11_80dB_0.4s.mat';
%     'soundfile_iba-uda_sourcefile_iba-da2+3.5oct.wav_12_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_iba-da3+3.5oct.wav_13_80dB_0.4s.mat';
%     'soundfile_iba-uda_sourcefile_iba-da4+3.5oct.wav_14_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_iba-da5+3.5oct.wav_15_80dB_0.4s.mat';
%     'soundfile_iba-uda_sourcefile_uba-da1+3.5oct.wav_21_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_uba-da2+3.5oct.wav_22_80dB_0.4s.mat';
%     'soundfile_iba-uda_sourcefile_uba-da3+3.5oct.wav_23_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_uba-da4+3.5oct.wav_24_80dB_0.4s.mat';
%     'soundfile_iba-uda_sourcefile_uba-da5+3.5oct.wav_25_80dB_0.4s.mat'};
%the_training_label_names{2} = 'soundfile_iba-uda_sourcefile_ba-da10+3.5oct.wav_10_80dB_0.4s.mat';
%{'soundfile_iba-uda_sourcefile_ba-da6+3.5oct.wav_6_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_ba-da7+3.5oct.wav_7_80dB_0.4s.mat';
%     'soundfile_iba-uda_sourcefile_ba-da8+3.5oct.wav_8_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_ba-da9+3.5oct.wav_9_80dB_0.4s.mat';
%     'soundfile_iba-uda_sourcefile_ba-da10+3.5oct.wav_10_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_iba-da6+3.5oct.wav_16_80dB_0.4s.mat'; 
%     'soundfile_iba-uda_sourcefile_iba-da7+3.5oct.wav_17_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_iba-da8+3.5oct.wav_18_80dB_0.4s.mat'; 
%     'soundfile_iba-uda_sourcefile_iba-da9+3.5oct.wav_19_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_iba-da10+3.5oct.wav_20_80dB_0.4s.mat'; 
%     'soundfile_iba-uda_sourcefile_uba-da6+3.5oct.wav_26_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_uba-da7+3.5oct.wav_27_80dB_0.4s.mat'; 
%     'soundfile_iba-uda_sourcefile_uba-da8+3.5oct.wav_28_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_uba-da9+3.5oct.wav_29_80dB_0.4s.mat'; 
%     'soundfile_iba-uda_sourcefile_uba-da10+3.5oct.wav_30_80dB_0.4s.mat'};
%the_training_label_names = {the_training_label_names_ba, the_training_label_names_da};
the_test_label_names = {'soundfile_iba-uda_sourcefile_ba-da2+3.5oct.wav_2_80dB_0.4s.mat';
     'soundfile_iba-uda_sourcefile_ba-da3+3.5oct.wav_3_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_ba-da4+3.5oct.wav_4_80dB_0.4s.mat';
     'soundfile_iba-uda_sourcefile_ba-da5+3.5oct.wav_5_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_ba-da6+3.5oct.wav_6_80dB_0.4s.mat';
     'soundfile_iba-uda_sourcefile_ba-da7+3.5oct.wav_7_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_ba-da8+3.5oct.wav_8_80dB_0.4s.mat';
     'soundfile_iba-uda_sourcefile_ba-da9+3.5oct.wav_9_80dB_0.4s.mat'};
%the_training_label_names{1};
%the_test_label_names{2} = 
%the_training_label_names{2};

% Settings in DS class - SFM 8/5/21
generalization_DS.time_periods_to_get_data_from = []; % May be needed for better FP or to isolate elements of a phoneme - SFM 8/5/21
%basic_DS.num_times_to_repeat_each_label_per_cv_split = k;
basic_DS.load_data_as_spike_counts = 1; % Default to 0, can also be basic_DS, need to turn on for Poisson Bayes CL - SFM 8/5/21
basic_DS.use_unique_data_in_each_cv_split = 1; % Maybe this will allow splitting this way (also works for basic_DS) - SFM 8/5/21
%basic_DS.specific_binned_label_names = []; % ^ same as above - SFM 8/5/21
basic_DS.label_names_to_use = []; 

ds_switch = 1; % Binary switch to change between generalization_DS or basic_DS - SFM 8/5/21
if ds_switch == 1
    ds = basic_DS(binned_data_file_name, specific_binned_label_names, num_cv_splits);
else
    ds = generalization_DS(binned_data_file_name, specific_binned_label_names, num_cv_splits, the_training_label_names, the_test_label_names);
end
toc

%%     Create FP

fp = zscore_normalize_FP;
   % select_or_exclude_top_k_features_FP;
   % select_pvalue_significant_features_FP;
toc

%%    Create CL 

cl = max_correlation_coefficient_CL;  
   % poisson_naive_bayes_CL;
   % libsvm_CL;

%%    CV

cv = standard_resample_CV(ds, cl);
cv.num_resample_runs = 60;

%All of these default to 0 - SFM 7/30/21
stop_resample_runs_only_when_specific_results_have_converged.decision_values = 1;
%cv.display_progress.zero_one_loss_results = 0;
%cv.display_progress.normalized_rank_results = 0;
cv.display_progress.convergence_values = 1;
cv.display_progress.decision_values = 1;
%cv.display_progress.combined_CV_ROC_results = 0;
%cv.display_progress.separate_CV_ROC_results = 0;

%%    Get Data!   

DECODING_RESULTS = cv.run_cv_decoding;
toc

%%    Save results

% save the results
save_file_name = 'SynthGroup5 Output v16';
save(save_file_name, 'DECODING_RESULTS');

%%    Plotting

% which results should be plotted (only have one result to plot here)
result_names{1} = save_file_name;
plot_obj = plot_standard_results_object(result_names);
plot_obj.significant_event_times = 0;   
% plot_obj.result_type_to_plot = 1;  % Default to 1 (zero-one-loss results) - SFM 8/4/21
plot_obj.plot_results;

%%    Plot the TCT matrix

plot_obj = plot_standard_results_TCT_object(save_file_name);
plot_obj.significant_event_times = 0; % the time when the stimulus was shown
% plot_obj.result_type_to_plot = 1;  % Default to 1 (zero-one-loss results) - SFM 8/4/21
plot_obj.plot_results;  % plot the TCT matrix and a movie showing if information is coded by a dynamic population code
toc
binned_data_file_name
%%
