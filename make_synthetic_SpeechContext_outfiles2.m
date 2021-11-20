% make_synthetic_SpeechContext_outfiles2

%modified from make_synthetic_SpeechContext_outfiles to add context effects for stimuli 11-30

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

%     to find an outfile that has spikes in it, load a combined outfile and
%     look in the outfilelist for the included ones (that have spikes)
cd    '/Volumes/wehrrig2b.uoregon.edu/lab/djmaus/Data/sfm/GrandKilosort0095CombinedOutfiles'


cd /Volumes/wehrrig2b.uoregon.edu/lab/djmaus/Data/sfm/2021-01-08_14-18-09_mouse-0095/
fprintf('\nloading outfile...')
load outPSTH_ch5c643.mat
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

cd /Volumes/wehrrig2b.uoregon.edu/lab/djmaus/Data/sfm/
if ~exist('synthetic_SpeechContext_data')
    mkdir synthetic_SpeechContext_data
end
cd synthetic_SpeechContext_data

if ~exist('Group12') %
    mkdir Group12
end
cd Group12

% SNR='low';
SNR='high';

% Group5: low SNR, differential
% Group6: high SNR, differential
% Group7: random
% Group8: single-ended high SNR
% Group9: single-ended low SNR
% Group10: high SNR, differential, only the timing changes (not magnitude)
% Group11: really high SNR, differential
% Group12: speech context effects for stim 11-30

for cell_idx=1:25
    
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
                    numspikes=randi(100, 1);
                    %generate N random spiketimes within xlimits
                    spiketimes=sort(randi(fix(out.xlimits), numspikes, 1))';
                    M1OFF(i,j,k, r).spiketimes=spiketimes;
                end
            end
        end
    end
    
    
    %modify M1OFF to impart tuning for ba and da
    if 1
        if cell_idx<10
            d=0;
            for i=[8 9 10 2] %last 4 ba-da files = da
                d=d+1;
                for j=1:out.numamps
                    for k=1:out.numdurs
                        for r=1:out.nrepsOFF(i,j,k)
                            %pick a random number of spikes
                            switch SNR
                                case 'low'
                                    numspikes=d*2 + randi(3, 1); %linearly tuned to da-ness, low SNR
                                case 'high'
                                    numspikes=d*5 + randi(5, 1); %linearly tuned to da-ness, high SNR
                                case 'reallyhigh'
                                    numspikes=d*15 + randi(5, 1); %linearly tuned to da-ness, high SNR
                                case 'timing'
                                    numspikes= 20;
                                otherwise
                                    error('WTF')
                            end
                            %generate N random spiketimes within xlimits
                            switch SNR
                                case 'timing'
                                    start=170+15*(d+4);
                                    stop=start+50;
                                    spiketimes=sort(randi(round([start stop]), numspikes, 1))';
                                otherwise
                                    spiketimes=sort(randi(round([200 350]), numspikes, 1))';
                            end
                            spiketimes=sort([spiketimes M1OFF(i,j,k, r).spiketimes]);
                            M1OFF(i,j,k, r).spiketimes=spiketimes;
                        end
                    end
                end
            end
        end
    end
    if 1
        if cell_idx>15
            d=0;
            for i=[1 3 4 5] %first 4 ba-da files = ba (file 2 is sourcefile 10)
                d=d+1;
                for j=1:out.numamps
                    for k=1:out.numdurs
                        for r=1:out.nrepsOFF(i,j,k)
                            %pick a random number of spikes
                            switch SNR
                                case 'low'
                                    numspikes=10-d*2 + randi(3, 1); %linearly tuned to ba-ness
                                case 'high'
                                    numspikes=25-5*d + randi(5, 1); %linearly tuned to ba-ness, high SNR
                                case 'reallyhigh'
                                    numspikes=75-15*d + randi(5, 1); %linearly tuned to ba-ness, high SNR
                                case 'timing'
                                    numspikes= 20;
                                otherwise
                                    error('WTF')
                            end
                            
                            %generate N random spiketimes within xlimits
                            switch SNR
                                case 'timing'
                                    start=170+15*d;
                                    stop=start+50;
                                    spiketimes=sort(randi(round([start stop]), numspikes, 1))';
                                otherwise
                                    spiketimes=sort(randi(round([200 350]), numspikes, 1))';
                            end
                            spiketimes=sort([spiketimes M1OFF(i,j,k, r).spiketimes]);
                            M1OFF(i,j,k, r).spiketimes=spiketimes;
                        end
                    end
                end
            end
        end
    end
    
    %     1-10: ba-da, in order 1 10 2 3 4 5 6 7 8 9
    %     11-20: iba-da, in order 1 10 2 3 4 5 6 7 8 9
    %     1-10: uba-da, in order 1 10 2 3 4 5 6 7 8 9
    
    % add i or u response 100 - 150
    % lower F2 = ba, higher F2 = da
    % i is a high F2
    % u is a low F2
    % i produces more ba choices
    % u produces more da choices
    % da cells respond to i and then less to da
    % ba cells respond to u and then less to ba
    
    %      modify ba/da in stimuli 11-20
    if 1
        if cell_idx<10 %da cells, respond to i but not u
            d=0;
            for i=[18 19 20 12] %last 4 ba-da files = da
                d=d+1;
                for j=1:out.numamps
                    for k=1:out.numdurs
                        for r=1:out.nrepsOFF(i,j,k)
                            %pick a random number of spikes
                            switch SNR
                                case 'low'
                                    numspikes=d*2 + randi(3, 1); %linearly tuned to da-ness, low SNR
                                case 'high'
                                    numspikes=d*5 + randi(5, 1); %linearly tuned to da-ness, high SNR
                                case 'reallyhigh'
                                    numspikes=d*15 + randi(5, 1); %linearly tuned to da-ness, high SNR
                                case 'timing'
                                    numspikes= 20;
                                otherwise
                                    error('WTF')
                            end
                            %generate N random spiketimes within xlimits
                            
                            spiketimes_da=sort(randi(round([200 350]), round(.5*numspikes), 1))';
                            
                            spiketimes=sort([spiketimes_da M1OFF(i,j,k, r).spiketimes]);
                            M1OFF(i,j,k, r).spiketimes=spiketimes;
                        end
                    end
                end
            end
            
            %add i response to stimuli 11-20 for da cells
            for i=[11:20] 
                for j=1:out.numamps
                    for k=1:out.numdurs
                        for r=1:out.nrepsOFF(i,j,k)
                            spiketimes_i=sort(randi(round([100 150]), 5, 1))';
                            spiketimes=sort([ spiketimes_i M1OFF(i,j,k, r).spiketimes]);
                            M1OFF(i,j,k, r).spiketimes=spiketimes;
                        end
                    end
                end
            end
        end
    end
    
    
    
    if 1
        if cell_idx>15 %ba cells, don't respond to i
            d=0;
            for i=[11 13 14 15] %first 4 ba-da files = ba (file 2 is sourcefile 10)
                d=d+1;
                for j=1:out.numamps
                    for k=1:out.numdurs
                        for r=1:out.nrepsOFF(i,j,k)
                            %pick a random number of spikes
                            switch SNR
                                case 'low'
                                    numspikes=10-d*2 + randi(3, 1); %linearly tuned to ba-ness
                                case 'high'
                                    numspikes=25-5*d + randi(5, 1); %linearly tuned to ba-ness, high SNR
                                case 'reallyhigh'
                                    numspikes=75-15*d + randi(5, 1); %linearly tuned to ba-ness, high SNR
                                case 'timing'
                                    numspikes= 20;
                                otherwise
                                    error('WTF')
                            end
                            
                            %generate N random spiketimes within xlimits
                            spiketimes_ba=sort(randi(round([200 350]), 1*numspikes, 1))';
                            
                            spiketimes=sort([spiketimes_ba M1OFF(i,j,k, r).spiketimes]);
                            M1OFF(i,j,k, r).spiketimes=spiketimes;
                        end
                    end
                end
            end
        end
    end
    
    
    %     add u and modify ba/da in stimuli 21-30
    if 1
        if cell_idx<10 %da cells, respond to i but not u
            d=0;
            for i=[28 29 30 22] %last 4 ba-da files = da
                d=d+1;
                for j=1:out.numamps
                    for k=1:out.numdurs
                        for r=1:out.nrepsOFF(i,j,k)
                            %pick a random number of spikes
                            switch SNR
                                case 'low'
                                    numspikes=d*2 + randi(3, 1); %linearly tuned to da-ness, low SNR
                                case 'high'
                                    numspikes=d*5 + randi(5, 1); %linearly tuned to da-ness, high SNR
                                case 'reallyhigh'
                                    numspikes=d*15 + randi(5, 1); %linearly tuned to da-ness, high SNR
                                case 'timing'
                                    numspikes= 20;
                                otherwise
                                    error('WTF')
                            end
                            %generate N random spiketimes within xlimits
                            
                            spiketimes_da=sort(randi(round([200 350]), 1*numspikes, 1))';
                            
                            spiketimes=sort([spiketimes_da M1OFF(i,j,k, r).spiketimes]);
                            M1OFF(i,j,k, r).spiketimes=spiketimes;
                        end
                    end
                end
            end
        end
    end
    if 1
        if cell_idx>15 %ba cells, respond to u, don't respond to i
            d=0;
            for i=[21 23 24 25] %first 4 ba-da files = ba (file 2 is sourcefile 10)
                d=d+1;
                for j=1:out.numamps
                    for k=1:out.numdurs
                        for r=1:out.nrepsOFF(i,j,k)
                            %pick a random number of spikes
                            switch SNR
                                case 'low'
                                    numspikes=10-d*2 + randi(3, 1); %linearly tuned to ba-ness
                                case 'high'
                                    numspikes=25-5*d + randi(5, 1); %linearly tuned to ba-ness, high SNR
                                case 'reallyhigh'
                                    numspikes=75-15*d + randi(5, 1); %linearly tuned to ba-ness, high SNR
                                case 'timing'
                                    numspikes= 20;
                                otherwise
                                    error('WTF')
                            end
                            
                            %generate N random spiketimes within xlimits
                            spiketimes_ba=sort(randi(round([200 350]), round(.5*numspikes), 1))';
                            
                            spiketimes=sort([spiketimes_ba  M1OFF(i,j,k, r).spiketimes]);
                            M1OFF(i,j,k, r).spiketimes=spiketimes;
                        end
                    end
                end
            end
            % %add u response to stimuli 21-30 for ba cells
            for i=[21:30] 
                for j=1:out.numamps
                    for k=1:out.numdurs
                        for r=1:out.nrepsOFF(i,j,k)
                            spiketimes_u=sort(randi(round([100 150]), 5, 1))';
                            spiketimes=sort([ spiketimes_u M1OFF(i,j,k, r).spiketimes]);
                            M1OFF(i,j,k, r).spiketimes=spiketimes;
                        end
                    end
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
    out.M1OFF=M1OFF;
    out.mM1OFF=mM1OFF;
    
    
    
    synthoutfilename=sprintf('outPSTH_synth_ch%dc%d.mat', cell_idx, cell_idx);
    fprintf('\nsaving synthetic outfile...')
    save(synthoutfilename, 'out', '-v7.3')
    fprintf('\nsaved %s in directory %s', synthoutfilename, pwd)
    fprintf('\n')
end























