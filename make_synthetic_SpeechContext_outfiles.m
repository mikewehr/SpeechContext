% make_synthetic_SpeechContext_outfiles

%script for making synthetic SpeechContext outfiles to test neural decoding
%workflow

% steps:
% load in an example outfile
% keep some fields intact
% replace M1 fields with random spiketimes
% change some stimulus responses to impart tuning
% save as a new outfile 
% repeat to generate outfiles for a population of cells
% repeat for different populations with different tuning effects 
%     -all random (negative control)
%     -differential responses to stimuli in different cells (best decoding)
%     -only responses to some stimuli (partial decoding?)
%     -could vary the proportion of responsive/random cells, or SNR of responses

cd /Volumes/wehrrig2b.uoregon.edu/lab/djmaus/Data/sfm/GrandKilosort0095CombinedOutfiles/
load outPSTH_combined_ch5c335.mat
% 
%          dirlist: {'/'  '/'}
%          targetdir: '/'
%       generated_by: 'Outfile_Combiner'
%       generated_on: '16-Jul-2021 10:56:18'
%        outfilelist: {1×2 cell}
%                 IL: 0
%               amps: [-1000 80]
%            numamps: 2
%               durs: [363.7340 364]
%            numdurs: 2
%          Nclusters: 1
%            tetrode: 5
%            channel: 5
%            cluster: 335
%               cell: 335
%        sourcefiles: {1×30 cell}
%     numsourcefiles: 30
%                 nb: [1×1 struct]
%           samprate: 30000
%            xlimits: [-181.8672 545.6016]
%              nreps: [30×2×2 double]
%           nrepsOFF: [30×2×2 double]
%            datadir: 'D:\lab\djmaus\Data\sfm\2020-12-18_14-27-02_mouse-0095'
%           datadirs: {'D:\lab\djmaus\Data\sfm\2020-12-18_14-27-02_mouse-0095'  'D:\lab\djmaus\Data\sfm\2021-01-08_14-18-09_mouse-0095'}
%            stimlog: [1×1280 struct]
%           stimlogs: {[1×1280 struct]  [1×1280 struct]}
%              M1OFF: [30×2×2×80 struct]
%             mM1OFF: [30×2×2 struct]

cell_idx=1;

out.generated_by = mfilename;
out.generated_on=datestr(now);
out.outfilelist=[];
out.tetrode=cell_idx;
out.channel=cell_idx;
out.cluster=cell_idx;
out.cell=cell_idx;
out.datadir=[];
out.datadirs=[];
























