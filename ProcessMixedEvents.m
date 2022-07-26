function [MasterEvents, Events] = ProcessMixedEvents(MasterEvents, Events)
% Rare use function (since this shouldn't happen) that parses an Events
% folder containing multiple stimuli types that can't be combined easily
% and manually combines each into a new struct

    for q = 1:length(Events)
        if strcmp(Events(q).type, 'tone') == 1
            if isempty(MasterEvents.Tuning)
                MasterEvents.Tuning = [MasterEvents.Tuning, Events(q)];
            else
                end_index = length(MasterEvents.Tuning) + 1;
                for fields = fieldnames(MasterEvents.Tuning)
                    for z = 1:length(fields)
                        fname = fields{z};
                        MasterEvents.Tuning(end_index).(fname) = Events(q).(fname);
                    end
                end
            end
        elseif strcmp(Events(q).type, 'soundfile') == 1
            if isempty(MasterEvents.Speech)
                MasterEvents.Speech = [MasterEvents.Speech, Events(q)];
            else
                end_index = length(MasterEvents.Speech) + 1;
                for fields = fieldnames(MasterEvents.Speech)
                    for z = 1:length(fields)
                        fname = fields{z};
                        MasterEvents.Speech(end_index).(fname) = Events(q).(fname);
                    end
                end
            end
        elseif strcmp(Events(q).type, 'silentsound') == 1 && Events(q).duration == 363.7340
            end_index = length(MasterEvents.Speech) + 1;
            for fields = fieldnames(MasterEvents.Speech)
                for z = 1:length(fields)
                    fname = fields{z};
                    MasterEvents.Speech(end_index).(fname) = Events(q).(fname);
                end
            end
        elseif strcmp(Events(q).type, 'silentsound') == 1 && Events(q).duration == 25
            end_index = length(MasterEvents.Tuning) + 1;
            for fields = fieldnames(MasterEvents.Tuning)
                for z = 1:length(fields)
                    fname = fields{z};
                    MasterEvents.Tuning(end_index).(fname) = Events(q).(fname);
                end
            end
        elseif strcmp(Events(q).type, 'whitenoise') == 1 && Events(q).duration == 363.7340
            end_index = length(MasterEvents.Speech) + 1;
            for fields = fieldnames(MasterEvents.Speech)
                for z = 1:length(fields)
                    fname = fields{z};
                    MasterEvents.Speech(end_index).(fname) = Events(q).(fname);
                end
            end
        elseif strcmp(Events(q).type, 'whitenoise') == 1 && Events(q).duration == 25
            end_index = length(MasterEvents.Tuning) + 1;
            for fields = fieldnames(MasterEvents.Tuning)
                for z = 1:length(fields)
                    fname = fields{z};
                    MasterEvents.Tuning(end_index).(fname) = Events(q).(fname);
                end
            end
        else
            error("Couldn't resolve stimuli, manually check stimlog")
        end
    end

end