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
fprintf('\nloading outfile...')
load outPSTH_combined_ch5c335.mat
fprintf('\tdone')
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

% generate M1OFF with random spiketimes
for i=1:out.numsourcefiles
    for j=1:out.numamps
        for k=1:out.numdurs
            for r=1:out.nrepsOFF(i,j,k)
            %pick a random number of spikes
            numspikes=randi(20, 1);
            %generate N random spiketimes within xlimits
            spiketimes=sort(randi(round(out.xlimits), numspikes, 1))';
            M1OFF(i,j,k, r).spiketimes=spiketimes;
            end
        end
    end
end
% Accumulate spiketimes across trials, for psth...
for dindex=1:out.numdurs;
    for aindex=[out.numamps:-1:1]
        for sourcefileidx=1:out.numsourcefiles
            % off
            spiketimesOFF=[];
            for rep=1:out.nrepsOFF(sourcefileidx, aindex, dindex)
                spiketimesOFF=[spiketimesOFF M1OFF(sourcefileidx, aindex, dindex, rep).spiketimes];
            end
            mM1OFF(sourcefileidx, aindex, dindex).spiketimes=spiketimesOFF;
        end
    end
end

cd /Volumes/wehrrig2b.uoregon.edu/lab/djmaus/Data/sfm/
mkdir synthetic_SpeechContext_data
cd synthetic_SpeechContext_data
synthoutfilename=sprintf('outPSTH_synth_ch%dc%d.mat', cell_idx, cell_idx);
fprintf('\nsaving synthetic outfile...')
save(synthoutfilename, 'out', '-v7.3')
fprintf('\nsaved %s in directory %s', synthoutfilename, pwd)
fprintf('\n')























