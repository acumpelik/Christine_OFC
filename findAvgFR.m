%% This script will find the average firing rate for all neurons.
%% Count spikes only from trials and windows

loadUsableDataset

numSessions = length(fnames);
avgfr_session = zeros(1, numSessions);

for session = 1:numSessions
    trialTimes = zeros(1, length(A{session}.start)); % trial durations
    
    if A{session}.hits == 1 % filter out sessions where the animal opted out (hits=0)
        hmatAvgFR_session = nanmean(A{session}.hmat, 2);
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

%% Plot average firing rates for each rat
rat_names = unique(rats); % print how many rats

nonzeroavgfr = nonzeros(avgfr_session')';

ratF077 = strcmp(rats, 'F077');
ratJ261 = strcmp(rats, 'J261');
ratJ298 = strcmp(rats, 'J298');

ratF077_fr = nonzeros(avgfr_session(ratF077));
ratJ261_fr = nonzeros(avgfr_session(ratJ261));
ratJ298_fr = nonzeros(avgfr_session(ratJ298));

figure(1)
clf
subplot(4,1,1); histogram(nonzeroavgfr, 60, 'BinEdges', [0:70])
    title('Average firing rate all rats')
    ylabel('Number of cells')
subplot(4,1,2); histogram(ratF077_fr, 60, 'BinEdges', [0:70])
    title('Rat F077')
    ylabel('Number of cells')
subplot(4,1,3); histogram(ratJ261_fr, 60, 'BinEdges', [0:70])
    title('Rat J261')
    ylabel('Number of cells')
subplot(4,1,4); histogram(ratJ298_fr, 60, 'BinEdges', [0:70])
    title('Rat J298')
    ylabel('Number of cells')
xlabel('Average firing rate (Hz)')


% trialTimes(trialTimes==0) = NaN
% strcmp(units{session}, 'single')==true

%% Find sessions where firing rate is above threshold
threshold = 30;
highfr = zeros(length(find(avgfr_session > threshold)), 2);

highfr(:, 2) = find(avgfr_session > threshold); % returns indices
highfr(:, 1) = avgfr_session(highfr(:, 2)); % returns values
highfr = sortrows(highfr, 'descend'); % sorted by descending avgfr values

%%
% % Plot all ISIs
% ISIs = diff(spiketimes);
% histogram(ISIs)
% title('Distribution of ISIs')
% xlabel('ISI (s)')
% ylabel('Number of neurons/sessions')
% 
% % Plot subset of ISIs below threshold
% smISIs = ISIs(ISIs < 0.02); % 20ms
% histogram(smISIs, 200)
% title('Distribution of ISIs below 20ms, bin size=200')
% xlabel('ISI (ms)')
% ylabel('Number of neurons/sessions')
% 
% length(smISIs)