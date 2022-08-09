function [MasterEvents] = ProcessAllEvents(varargin)
% Run ProcessEvents across all directories for a given mouse and combine
% them based on the master directory. Input can be a master directory string or a
% list of master directories 
    
    for iVarargin = 1:length(varargin)
        if isstring(varargin{1})
        else
            error("One of these inputs isn't a string, make sure your directories are input correctly!")
        end
    end
    datadir = varargin;

    for iMouse = 1:length(datadir)
        load(fullfile(datadir{iMouse}, 'dirs.mat');
        temp_str = strsplit(pwd, '-');
        mouseID = temp_str{end};
        load(fullfile(datadir{iMouse},'rez.mat'))
        L = (rez.ops.recLength)/sp.sample_rate;
        save(fullfile(datadir{iMouse},'RecLengths.mat'),'L')
        sampleRate = sp.sample_rate;
        for i = 1:length(dirs)
            [Events] = ProcessEvents(dirs{i});
            load(fullfile(dirs{i}, 'notebook.mat'));
            
            if i == 1
                MasterStimlog = stimlog;
                if strcmp(Events(1).type, 'soundfile') == 1
                    speech_fieldnames = fieldnames(Events);
                    MasterEvents.Speech = Events;
                    MasterEvents.Tuning = struct([]);
                elseif strcmp(Events(1).type, 'tone') == 1
                    tuning_fieldnames = fieldnames(Events);
                    MasterEvents.Tuning = Events;
                    MasterEvents.Speech = struct([]);
                else
                    error("This doesn't appear to be recording either tuning curves or speech context protocols, this function may need to be edited to include more stimulus types")
                end
            else
                MasterStimlog = [MasterStimlog stimlog];
                start_acq_samp = L(i - 1) * sampleRate;
                for m = 1:length(Events)
                    Events(m).message_timestamp_sec = Events(m).message_timestamp_sec + L(i - 1);
                    Events(m).soundcard_trigger_timestamp_sec = Events(m).soundcard_trigger_timestamp_sec + L(i - 1);
                    Events(m).message_timestamp_samples = Events(m).message_timestamp_samples + start_acq_samp;
                end
                
                clear temp_stim_types
                for i = 1:length(Events)
                    temp_stim_types{i} = Events(i).type;
                end
                types_of_stims = unique(temp_stim_types);
                if length(types_of_stims) > 3                               % If there are more than 3 types of stimuli, you are probably try to combine multiple different stimulus types
                    [MasterEvents] = ProcessMixedEvents(MasterEvents, Events);
                elseif length(types_of_stims) == 3
                    if strcmp(Events(1).type, 'soundfile') == 1
                        MasterEvents.Speech = [MasterEvents.Speech, Events];
                    elseif strcmp(Events(1).type, 'tone') == 1
                        if isfield(MasterEvents.Tuning, 'sourcefile')
                            MasterEvents.Tuning = rmfield(MasterEvents.Tuning, 'sourcefile');
                        end
                        if isfield(MasterEvents.Tuning, 'sourcepath')
                            MasterEvents.Tuning = rmfield(MasterEvents.Tuning, 'sourcepath');
                        end
                        MasterEvents.Tuning = [MasterEvents.Tuning, Events];
                    end
                else
                    error("Unexpected number of types of stimuli, what experiment did you run?")
                end
            end
        end
        save(fullfile(datadir{iMouse}, 'MasterEvents.mat'), 'MasterEvents', 'L', 'sampleRate');
        save(fullfile(datadir{iMouse}, 'MasterStimlog.mat'), 'MasterStimlog');
    end
end