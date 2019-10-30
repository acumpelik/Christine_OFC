% function find_avgfr
% This function will find the average firing rate for all neurons that are not multiunit.
% dependencies: none except for data

[fnames, units, ~, ~, rats] = getfnames; % get the filenames from the excel sheet, and determine whether multiunit

%% Count spikes only from trials and windows

avgfr_session = zeros(1, length(fnames));

for session = 1:length(fnames)
    % Load .mat.mat file from parsed_data folder; filesep puts slash
    load(strcat(['parsed_data', filesep, fnames{session}, '.mat']));
    trialTimes = zeros(1, length(handles.start)); % trial durations
    
    %%% COUNT ONLY SPIKES FROM TRIALS & WINDOWS
    % Exclude multiunit neurons/sessions
    if strcmp(units{session}, 'single')==true % comparing strings; if unit is single
        % Count spikes in trials and windows
        % Set window to 1 second
        n = nspikespertrials(spiketimes, handles, 1);
        
        % Make vector for each trial, which will have the average firing rate for that trial
        avgfr_trials = zeros(1, length(n));
        
        % Only count neurons that fire more than twice per trial and mean firing rate is greater than .5
        nk = n>=2; % (the output of this a logical)
        if nanmean(nk)>=.5
%             % sum all the spikes
%             totalSpikes = sum(n); % sum of spikes

            for trial = 1:length(trialTimes)
                % find each trial's duration
                trialTimes(trial) = handles.end(trial)-handles.start(trial);
                % if the trial duration is 0, make it a NaN so it doesn't crash later
                trialTimes(trialTimes==0) = NaN;
                % add window times
                trialTimes = trialTimes+2;
                % find the average: divide number of spikes per trial by its duration
                avgfr_trials(trial) = n(trial) / trialTimes(trial);
            end

% %             find the total duration for all trials
%             durationAllTrials = sum(trialTimes);
            
%             % calculate the total average firing rate
%             avgfr(session) = totalSpikes / durationAllTrials;

            % find the average firing rate for all sessions
            avgfr_session(session) = nanmean(avgfr_trials);
        end
    end
end

%% Plot average firing rates
% exclude zeros
nonzeroavgfr = nonzeros(avgfr_session')';
% plot
histogram(nonzeroavgfr, 80);
title('Average firing rate distribution over all sessions (w/o ITIs)')
xlabel('Average firing rate (spikes per s)')
ylabel('Number of neurons')

%% Find sessions where firing rate is above threshold
% threshold = 30;
% highfr = zeros(length(find(avgfr_session > threshold)), 2);
% 
% highfr(:, 2) = find(avgfr_session > threshold); % returns indices
% highfr(:, 1) = avgfr_session(highfr(:, 2)); % returns values
% highfr = sortrows(highfr, 'descend'); % sorted by descending avgfr values