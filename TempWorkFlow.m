%% Modified Workflow (Working Working Workflow)
% Preprocessing after clustering

clear all
tic;
preprocess_switch = 0; % Logical switch on whether to generate outfiles and rasterize them - SFM 8/5/21
if preprocess_switch == 1
    outdirs = 'D:\lab\djmaus\Data\sfm\'; % Set target dir for outfiles to be generated
    for i = 1:length(outdirs)
        cd(outdirs{i})
        PlotSpeechContext
    end
    GrandOutfile_Combiner.masterdir = []; %outdirs; % Set master directory where single outfiles are located - SFM 8/5/21
    GrandOutfile_Combiner.targetdir = []; % Set directory for combined outfiles to be saved to - SFM 8/5/21
    for j = 1:length(GrandOutfile_Combiner.masterdir)
        l = 1:length(GrandOutfile_Combiner.targetdir);
        cd(GrandOutfile_Combiner.masterdir{j})
        GrandOutfile_Combiner.targetdir{l};
        GrandOutfile_Combiner;
    end
    cd(targetdir);
    convert_outfile_to_raster_format_sfm.datadir = GrandOutfile_Combiner.targetdir;
    for j = 1:length(convert_outfile_to_raster_format_sfm.datadir)
        cd(datadir{j})
        convert_outfile_to_raster_format_sfm;
    end
    toc
else
end

clear all

%%  Binning Data

BinnedDir = 'F:\Data\sfm\BinnedFiles'; % Set directory where binned files are located - SFM 8/6/21 
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
    toc
else
    binned_data_file_name = Previous_data_file_name 
end                     % 'Binned_Zhang_Desimone_7object_data_150ms_bins_50ms_sampled.mat' example dataset binned - SFM 7/28/21

%%  Optional Utility Function

load(binned_data_file_name);
k_label_utility_switch = 0;

if k_label_utility_switch == 1
    for k = 1:100
        inds_of_sites_with_at_least_k_repeats = find_sites_with_k_label_repetitions(binned_labels.sourcefile, k);
        num_sites_with_k_repeats(k) = length(inds_of_sites_with_at_least_k_repeats); 
    end
    toc
else
end

%%    Create DS

specific_binned_label_names = binned_labels.sourcefile; %.stimulus_ID for example data - SFM 7/28/21
num_cv_splits = 20; 

set_training_and_testing_labels = 'none';

if strcmp(set_training_and_testing_labels, 'none') == 1
    the_training_label_names{1} = {'soundfile_iba-uda_sourcefile_ba-da1+3.5oct.wav_1_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_ba-da10+3.5oct.wav_10_80dB_0.4s.mat'};
    %{'soundfile_iba-uda_sourcefile_ba-da1+3.5oct.wav_1_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_ba-da10+3.5oct.wav_10_80dB_0.4s.mat'};
    %{'soundfile_iba-uda_sourcefile_iba-da1+3.5oct.wav_11_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_iba-da10+3.5oct.wav_20_80dB_0.4s.mat'}; 
    %{'soundfile_iba-uda_sourcefile_uba-da1+3.5oct.wav_21_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_uba-da10+3.5oct.wav_30_80dB_0.4s.mat'};
    the_test_label_names{1} = {'soundfile_iba-uda_sourcefile_ba-da2+3.5oct.wav_2_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_ba-da3+3.5oct.wav_3_80dB_0.4s.mat'; 
        'soundfile_iba-uda_sourcefile_ba-da4+3.5oct.wav_4_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_ba-da5+3.5oct.wav_5_80dB_0.4s.mat'; 
        'soundfile_iba-uda_sourcefile_ba-da6+3.5oct.wav_6_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_ba-da7+3.5oct.wav_7_80dB_0.4s.mat'; 
        'soundfile_iba-uda_sourcefile_ba-da8+3.5oct.wav_8_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_ba-da9+3.5oct.wav_9_80dB_0.4s.mat';
        'soundfile_iba-uda_sourcefile_iba-da1+3.5oct.wav_11_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_iba-da10+3.5oct.wav_20_80dB_0.4s.mat';
        'soundfile_iba-uda_sourcefile_iba-da2+3.5oct.wav_12_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_iba-da3+3.5oct.wav_13_80dB_0.4s.mat'; 
        'soundfile_iba-uda_sourcefile_iba-da4+3.5oct.wav_14_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_iba-da5+3.5oct.wav_15_80dB_0.4s.mat'; 
        'soundfile_iba-uda_sourcefile_iba-da6+3.5oct.wav_16_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_iba-da7+3.5oct.wav_17_80dB_0.4s.mat'; 
        'soundfile_iba-uda_sourcefile_iba-da8+3.5oct.wav_18_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_iba-da9+3.5oct.wav_19_80dB_0.4s.mat';
        'soundfile_iba-uda_sourcefile_uba-da1+3.5oct.wav_21_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_uba-da10+3.5oct.wav_30_80dB_0.4s.mat';
        'soundfile_iba-uda_sourcefile_uba-da2+3.5oct.wav_22_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_uba-da3+3.5oct.wav_23_80dB_0.4s.mat'; 
        'soundfile_iba-uda_sourcefile_uba-da4+3.5oct.wav_24_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_uba-da5+3.5oct.wav_25_80dB_0.4s.mat'; 
        'soundfile_iba-uda_sourcefile_uba-da6+3.5oct.wav_26_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_uba-da7+3.5oct.wav_27_80dB_0.4s.mat'; 
        'soundfile_iba-uda_sourcefile_uba-da8+3.5oct.wav_28_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_uba-da9+3.5oct.wav_29_80dB_0.4s.mat'};
    
elseif strcmp(set_training_and_testing_labels, 'i') == 1
    the_training_label_names{1} = {'soundfile_iba-uda_sourcefile_iba-da1+3.5oct.wav_11_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_iba-da10+3.5oct.wav_20_80dB_0.4s.mat'};
    %{'soundfile_iba-uda_sourcefile_ba-da1+3.5oct.wav_1_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_ba-da10+3.5oct.wav_10_80dB_0.4s.mat'};
    %{'soundfile_iba-uda_sourcefile_iba-da1+3.5oct.wav_11_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_iba-da10+3.5oct.wav_20_80dB_0.4s.mat'}; 
    %{'soundfile_iba-uda_sourcefile_uba-da1+3.5oct.wav_21_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_uba-da10+3.5oct.wav_30_80dB_0.4s.mat'};
    the_test_label_names{1} = {'soundfile_iba-uda_sourcefile_ba-da1+3.5oct.wav_1_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_ba-da10+3.5oct.wav_10_80dB_0.4s.mat';
        'soundfile_iba-uda_sourcefile_ba-da2+3.5oct.wav_2_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_ba-da3+3.5oct.wav_3_80dB_0.4s.mat'; 
        'soundfile_iba-uda_sourcefile_ba-da4+3.5oct.wav_4_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_ba-da5+3.5oct.wav_5_80dB_0.4s.mat'; 
        'soundfile_iba-uda_sourcefile_ba-da6+3.5oct.wav_6_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_ba-da7+3.5oct.wav_7_80dB_0.4s.mat'; 
        'soundfile_iba-uda_sourcefile_ba-da8+3.5oct.wav_8_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_ba-da9+3.5oct.wav_9_80dB_0.4s.mat';
        'soundfile_iba-uda_sourcefile_iba-da2+3.5oct.wav_12_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_iba-da3+3.5oct.wav_13_80dB_0.4s.mat'; 
        'soundfile_iba-uda_sourcefile_iba-da4+3.5oct.wav_14_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_iba-da5+3.5oct.wav_15_80dB_0.4s.mat'; 
        'soundfile_iba-uda_sourcefile_iba-da6+3.5oct.wav_16_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_iba-da7+3.5oct.wav_17_80dB_0.4s.mat'; 
        'soundfile_iba-uda_sourcefile_iba-da8+3.5oct.wav_18_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_iba-da9+3.5oct.wav_19_80dB_0.4s.mat';
        'soundfile_iba-uda_sourcefile_uba-da1+3.5oct.wav_21_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_uba-da10+3.5oct.wav_30_80dB_0.4s.mat';
        'soundfile_iba-uda_sourcefile_uba-da2+3.5oct.wav_22_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_uba-da3+3.5oct.wav_23_80dB_0.4s.mat'; 
        'soundfile_iba-uda_sourcefile_uba-da4+3.5oct.wav_24_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_uba-da5+3.5oct.wav_25_80dB_0.4s.mat'; 
        'soundfile_iba-uda_sourcefile_uba-da6+3.5oct.wav_26_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_uba-da7+3.5oct.wav_27_80dB_0.4s.mat'; 
    'soundfile_iba-uda_sourcefile_uba-da8+3.5oct.wav_28_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_uba-da9+3.5oct.wav_29_80dB_0.4s.mat'}; 

elseif strcmp(set_training_and_testing_labels, 'u') == 1
    the_training_label_names{1} = {'soundfile_iba-uda_sourcefile_uba-da1+3.5oct.wav_21_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_uba-da10+3.5oct.wav_30_80dB_0.4s.mat'};
    %{'soundfile_iba-uda_sourcefile_ba-da1+3.5oct.wav_1_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_ba-da10+3.5oct.wav_10_80dB_0.4s.mat'};
    %{'soundfile_iba-uda_sourcefile_iba-da1+3.5oct.wav_11_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_iba-da10+3.5oct.wav_20_80dB_0.4s.mat'}; 
    %{'soundfile_iba-uda_sourcefile_uba-da1+3.5oct.wav_21_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_uba-da10+3.5oct.wav_30_80dB_0.4s.mat'};
    the_test_label_names{1} = {'soundfile_iba-uda_sourcefile_ba-da1+3.5oct.wav_1_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_ba-da10+3.5oct.wav_10_80dB_0.4s.mat';
        'soundfile_iba-uda_sourcefile_ba-da2+3.5oct.wav_2_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_ba-da3+3.5oct.wav_3_80dB_0.4s.mat'; 
        'soundfile_iba-uda_sourcefile_ba-da4+3.5oct.wav_4_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_ba-da5+3.5oct.wav_5_80dB_0.4s.mat'; 
        'soundfile_iba-uda_sourcefile_ba-da6+3.5oct.wav_6_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_ba-da7+3.5oct.wav_7_80dB_0.4s.mat'; 
        'soundfile_iba-uda_sourcefile_ba-da8+3.5oct.wav_8_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_ba-da9+3.5oct.wav_9_80dB_0.4s.mat';
        'soundfile_iba-uda_sourcefile_iba-da1+3.5oct.wav_11_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_iba-da10+3.5oct.wav_20_80dB_0.4s.mat';
        'soundfile_iba-uda_sourcefile_iba-da2+3.5oct.wav_12_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_iba-da3+3.5oct.wav_13_80dB_0.4s.mat'; 
        'soundfile_iba-uda_sourcefile_iba-da4+3.5oct.wav_14_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_iba-da5+3.5oct.wav_15_80dB_0.4s.mat'; 
        'soundfile_iba-uda_sourcefile_iba-da6+3.5oct.wav_16_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_iba-da7+3.5oct.wav_17_80dB_0.4s.mat'; 
        'soundfile_iba-uda_sourcefile_iba-da8+3.5oct.wav_18_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_iba-da9+3.5oct.wav_19_80dB_0.4s.mat';
        'soundfile_iba-uda_sourcefile_uba-da2+3.5oct.wav_22_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_uba-da3+3.5oct.wav_23_80dB_0.4s.mat'; 
        'soundfile_iba-uda_sourcefile_uba-da4+3.5oct.wav_24_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_uba-da5+3.5oct.wav_25_80dB_0.4s.mat'; 
        'soundfile_iba-uda_sourcefile_uba-da6+3.5oct.wav_26_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_uba-da7+3.5oct.wav_27_80dB_0.4s.mat'; 
        'soundfile_iba-uda_sourcefile_uba-da8+3.5oct.wav_28_80dB_0.4s.mat'; 'soundfile_iba-uda_sourcefile_uba-da9+3.5oct.wav_29_80dB_0.4s.mat'};
else
    the_training_label_names = [];
    the_testing_label_names = [];
end

% Settings in DS class
% basic_DS.time_periods_to_get_data_from = []; % May be needed for better FP or to isolate elements of a phoneme - SFM 8/5/21
% basic_DS.num_times_to_repeat_each_label_per_cv_split = k; % Need to have run utility function above to set this to k
% basic_DS.specific_binned_label_names = []; % ^ same as above, default is all 30 stims (see above) - SFM 8/5/21
% basic_DS.label_names_to_use = the_test_label_names;
% basic_DS.randomly_shuffle_labels_before_running = 0; % Set to 1 to take a null distribution - SFM 8/5/21
% none of these like being piped in, need to be manually set in the respective *_DS function - SFM 8/5/21

ds_switch = 0;          % Binary switch to change between generalization_DS or basic_DS - SFM 8/5/21
poisson_switch = 0;     % Binary switch needed to be switched on if using poisson_naive_bayes_FP - SFM 8/9/21

if ds_switch == 1
    if poisson_switch == 1
        load_data_as_spike_counts = 1;
        ds = basic_DS(binned_data_file_name, specific_binned_label_names, num_cv_splits, load_data_as_spike_counts);
    else
        ds = basic_DS(binned_data_file_name, specific_binned_label_names, num_cv_splits);
    end
else
    if poisson_switch == 1
        load_data_as_spike_counts = 1;
%         generalization_DS.use_unique_data_in_each_cv_split = 0;     % Defaults to 0 - SFM 8/9/21
        ds = generalization_DS(binned_data_file_name, specific_binned_label_names, num_cv_splits, the_training_label_names, the_test_label_names, load_data_as_spike_counts);
    else
%         generalization_DS.use_unique_data_in_each_cv_split = 0;     % Defaults to 0 - SFM 8/9/21
        ds = generalization_DS(binned_data_file_name, specific_binned_label_names, num_cv_splits, the_training_label_names, the_test_label_names);
    end
end

%%     Create FP (optional)

set_fp_type = 0;    % Set switch on type of feature preprocessing to use - SFM 8/9/21
if set_fp_type == 0
    fp = zscore_normalize_FP;
elseif set_fp_type == 1
    fp = select_or_exclude_top_k_features_FP;
else
    select_pvalue_significant_features_FP.pvalue_threshold = 0.01;   % Needs to be set - SFM 8/9/21
    fp = select_pvalue_significant_features_FP;
end

%%    Create CL 

set_cl_type = 2;    % Set switch on type of classifier to use - SFM 8/9/21
if set_cl_type == 0
    cl = max_correlation_coefficient_CL;
elseif set_cl_type == 1
    cl = poisson_naive_bayes_CL;
    cl.lambdas = 100;                          % How many times do you expect each neuron to have been presented each soundfile? - SFM 8/9/21
    cl.labels = the_test_label_names{1,1};     % What are the potential labels each neuron can have? - SFM 8/9/21
else
    cl = libsvm_CL;
end

%%    CV

set_fp_flag = 0;    % Set binary switch whether to run decoding with FP or not - SFM 8/9/21
if set_fp_flag == 0
    cv = standard_resample_CV(ds, cl);
else 
    cv = standard_resample_CV(ds, cl, fp);
end

cv.num_resample_runs = 60;

%All of these default to 0 - SFM 7/30/21
stop_resample_runs_only_when_specific_results_have_converged.decision_values = 0;
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
save_file_name = 'SynthGroup5 Output v27';
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
