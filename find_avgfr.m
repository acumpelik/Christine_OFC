function find_avgfr
% This function will find the average firing rate for all neurons that are not multiunit.

[fnames, units, ~, ~, rats] = getfnames; % get the filenames from the excel sheet, and determine whether multiunit

%% Count spikes for entire session (including ITIs)
% % Make a vector with all the sessions/units
% avgfrAll = zeros(1, length(fnames));
% 
% for session = 1:length(fnames)
%     load(strcat(['parsed_data', filesep, fnames{session}, '.mat']));
%     % Count all the spikes in a session, including ITIs
%     avgfrAll(1, session) = length(spiketimes) / (handles.end(end)-handles.start(1));
%     
%     histogram(avgfrAll, 50)
%     title('Average firing rate distribution over all sessions')
%     xlabel('Average firing rate (spikes per s)')
%     ylabel('Number of neurons')
%     hold on
% end


%% Count spikes only from trials and windows

avgfr_session = zeros(1, length(fnames));

for session = 1:length(fnames)
    % Load .mat.mat file from parsed_data folder; filesep puts slash
    load(strcat(['parsed_data', filesep, fnames{session}, '.mat']));
    trialTimes = zeros(1, length(handles.start)); % trial durations
    
    %%% COUNT ONLY SPIKES FROM TRIALS & WINDOWS
    % Exclude multiunit neurons/sessions
    if strcmp(units{session}, 'single')==true % comparing strings
        % Count spikes in trials and windows, set window to 1 second
        n = nspikespertrials(spiketimes, handles, 1); % set window to 1s
        avgfr_trials = zeros(1, length(n)); % a vector of avg firing rates for each trial w/i session
        
        % Only count neurons that: 1) fire more than twice per trial
        nk = n>=2; % the output of this a logical
        if nanmean(nk)>=.5
%             totalSpikes = sum(n); % sum of spikes

            for trial = 1:length(trialTimes)
                trialTimes(trial) = handles.end(trial)-handles.start(trial); %%% ADD WINDOWS
                %%% DIVIDE EACH TRIAL'S SPIKES BY EACH TRIAL'S DURATION
                trialTimes(trialTimes==0) = NaN;
                trialTimes = trialTimes+2;
                avgfr_trials(trial) = n(trial) / trialTimes(trial);
            end


%             durationAllTrials = sum(trialTimes); % total time%
            
            % calculate average firing rate
%             avgfr(session) = totalSpikes / durationAllTrials;

            avgfr_session(session) = nanmean(avgfr_trials);
%             h1 = histogram(avgfr_session);
%             title('Average firing rate distribution over all sessions (in ITIs and windows')
%             xlabel('Average firing rate (spikes/s)')
%             ylabel('Number of neurons')
%             hold on
        end
 
    end
end

%% Plot average firing rates
nonzeroavgfr = nonzeros(avgfr_session')';
histogram(nonzeroavgfr, 80);
title('Average firing rate distribution over all sessions (w/o ITIs)')
xlabel('Average firing rate (spikes per s)')
ylabel('Number of neurons')

%% Find sessions where firing rate is above threshold
threshold = 30;
highfr = zeros(length(find(avgfr_session > threshold)), 2);

highfr(:, 2) = find(avgfr_session > threshold); % returns indices
highfr(:, 1) = avgfr_session(highfr(:, 2)); % returns values
highfr = sortrows(highfr, 'descend'); % sorted by descending avgfr values


%% Plot all ISIs
ISIs = diff(spiketimes);
histogram(ISIs)
title('Distribution of ISIs')
xlabel('ISI (s)')
ylabel('Number of neurons/sessions')

%% Plot subset of ISIs below threshold
smISIs = ISIs(ISIs < 0.02); % 20ms
histogram(smISIs, 200)
title('Distribution of ISIs below 20ms, bin size=200')
xlabel('ISI (ms)')
ylabel('Number of neurons/sessions')

length(smISIs)

