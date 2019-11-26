%% generate heatmap of all rewarded session
loadUsableDataset

% first define a heatmap mask with filtered (usable) sessions
hmat_grouped = zeros(numUsableSessions,numel(A{1}.xvec));

% create masks
usableInds = find(usableVec);               % indices of usable sessions
avgSpikesPerSession_grouped = zeros(numUsableSessions,1); % define mask for avg # of spikes per session
hmat_R6 = zeros(numUsableSessions, length(A{1}.xvec));
avgSpikesPerSession_R6 = zeros(numUsableSessions,1); % define mask for avg # of spikes per session
hmat_R12 = zeros(numUsableSessions, length(A{1}.xvec));
avgSpikesPerSession_R12 = zeros(numUsableSessions,1); % define mask for avg # of spikes per session
hmat_R24 = zeros(numUsableSessions, length(A{1}.xvec));
avgSpikesPerSession_R24 = zeros(numUsableSessions,1); % define mask for avg # of spikes per session
hmat_R48 = zeros(numUsableSessions, length(A{1}.xvec));
avgSpikesPerSession_R48 = zeros(numUsableSessions,1); % define mask for avg # of spikes per session

% loop over each session, and add PSTH to hmat;
for session = 1:numUsableSessions
    if  A{usableInds(session)}.isUsable           % if session is usable, grab correct index
     % binned spikes for usable sessions
     hmat_grouped(session,:) = nanmean( A{usableInds(session)}.hmat,1 );

     % filter out trials with 6uL
     R6trialsMask = A{usableInds(session)}.chosenval==6; % logical with trials where rat gets 6uL
     numR6trials = sum(R6trialsMask); % count 6uL trials
     R6trialInds = find(R6trialsMask); % find 6uL indices
     R6trials = zeros(numR6trials, length(A{1}.xvec)); % designate matrix with 6uL trials for session
         for trial = 1:numR6trials
             % copy avg FR for 6uL trial
             R6trials(trial, :) = A{usableInds(session)}.hmat(R6trialInds(trial), :);
         end
     % filter out trials with 12uL
     R12trialsMask = A{usableInds(session)}.chosenval==12; % logical with trials where rat gets 12uL
     numR12trials = sum(R12trialsMask); % count 12uL trials
     R12trialInds = find(R12trialsMask); % find 12uL indices
     R12trials = zeros(numR12trials, length(A{1}.xvec)); % designate matrix with 12uL trials for session
         for trial = 1:numR12trials
             % copy avg FR for 12uL trial
             R12trials(trial, :) = A{usableInds(session)}.hmat(R12trialInds(trial), :);
         end
    % filter out trials with 24uL
     R24trialsMask = A{usableInds(session)}.chosenval==24; % logical with trials where rat gets 24uL
     numR24trials = sum(R24trialsMask); % count 24uL trials
     R24trialInds = find(R24trialsMask); % find 24uL indices
     R24trials = zeros(numR24trials, length(A{1}.xvec)); % designate matrix with 24uL trials for session
         for trial = 1:numR24trials
             % copy avg FR for 24uL trial
             R24trials(trial, :) = A{usableInds(session)}.hmat(R24trialInds(trial), :);
         end     
     % filter out trials with 48uL
     R48trialsMask = A{usableInds(session)}.chosenval==48; % logical with trials where rat gets 48uL
     numR48trials = sum(R48trialsMask); % count 48uL trials
     R48trialInds = find(R48trialsMask); % find 48uL indices
     R48trials = zeros(numR48trials, length(A{1}.xvec)); % designate matrix with 48uL trials for session
         for trial = 1:numR48trials
             % copy avg FR for 48uL trial
             R48trials(trial, :) = A{usableInds(session)}.hmat(R48trialInds(trial), :);
         end    
    end
    
    % average number (over trials) of spikes for each session.
    avgSpikesPerSession_grouped(session) = nanmean(A{usableInds(session)}.nspikes);
    
    % 1. average trials from this session and add to RVol heatmaps
    % 2. average number of spikes per trial per session
    hmat_R6(session, :) = mean(R6trials);
    avgSpikesPerSession_R6(session) = nanmean(A{usableInds(session)}.nspikes);
    hmat_R12(session, :) = mean(R12trials);
    avgSpikesPerSession_R12(session) = nanmean(A{usableInds(session)}.nspikes);
    hmat_R24(session, :) = mean(R24trials);
    avgSpikesPerSession_R24(session) = nanmean(A{usableInds(session)}.nspikes);
    hmat_R48(session, :) = mean(R48trials);
    avgSpikesPerSession_R48(session) = nanmean(A{usableInds(session)}.nspikes);
    
end

%% normalize (z-score) heatmap and plot
% order the data for the grouped hmat
[sessionsByNumSpikes,indicesAvgNumSpikes] = sort(avgSpikesPerSession_grouped);
hmat_grouped_sorted = hmat_grouped(indicesAvgNumSpikes,:);

% z-score
avgFR_allsessions = mean(hmat_grouped_sorted, 2);  % find mean of hmat_sess_sorted rows
std_allsessions = std(hmat_grouped_sorted, 0, 2);  % find STD of hmat_sess_sorted rows; w = 0 (default)
normalized_hmat = (hmat_grouped_sorted - avgFR_allsessions) ./ std_allsessions;

% z-score for R6, maintaining the order according to the grouped hmat and the avg and std
hmat_R6_sorted = hmat_R6(indicesAvgNumSpikes, :);
normalized_hmat_R6 = (hmat_R6_sorted- avgFR_allsessions) ./ std_allsessions;

% repeat for other reward volumes
hmat_R12_sorted = hmat_R12(indicesAvgNumSpikes, :);
normalized_hmat_R12 = (hmat_R12_sorted- avgFR_allsessions) ./ std_allsessions;
hmat_R24_sorted = hmat_R24(indicesAvgNumSpikes, :);
normalized_hmat_R24 = (hmat_R24_sorted- avgFR_allsessions) ./ std_allsessions;
hmat_R48_sorted = hmat_R48(indicesAvgNumSpikes, :);
normalized_hmat_R48 = (hmat_R48_sorted- avgFR_allsessions) ./ std_allsessions;


%%
% arrange by peak onset
peakrange_min = 21; %first time bin to look for the peak
peakrange_max = 61; %last time bin to look for the peak

peaktime = zeros(1,numUsableSessions);
for session = 1:numUsableSessions
    [peakmax,pind] = max(normalized_hmat(session,peakrange_min:peakrange_max));
    peaktime(session) = A{1}.xvec(pind);
end

[B_pmax,I_pmax] = sort(peaktime);
hmat_grouped_zscore_peaksorted = normalized_hmat(I_pmax,:);
hmat_grouped_peaksorted = hmat_grouped_sorted(I_pmax,:);

% sort other reward volumes, maintaining the peak ordering
hmat_R6_zscore_peaksorted = normalized_hmat_R6(I_pmax,:);
hmat_R12_zscore_peaksorted = normalized_hmat_R12(I_pmax,:);
hmat_R24_zscore_peaksorted = normalized_hmat_R24(I_pmax,:);
hmat_R48_zscore_peaksorted = normalized_hmat_R48(I_pmax,:);

%%
% plot
figure(1)
imagesc(A{1}.xvec, 1:numUsableSessions, hmat_grouped_zscore_peaksorted) % normalized_hmat
title('z-scored heatmap of average firing rate for each session; aligned to trial start')
colormap default
caxis([-6, 4])
xlabel('time (s)')
ylabel('session')
set(gca,'fontsize',13)
set(gca, 'TickDir', 'out'); box off; colorbar

figure(2)
imagesc(A{1}.xvec, 1:numUsableSessions, hmat_R6_zscore_peaksorted) %R6trialsAvgOverSession
% imagesc(A{1}.xvec, 1:numUsableSessions, normalized_hmat) % normalized_hmat

title(...
    'z-scored heatmap of average firing rate for 6 uL trials within each session; sorted by peak onset')
colormap default
caxis([-6, 4])
xlabel('time (s)')
ylabel('session')
set(gca,'fontsize',13)
set(gca, 'TickDir', 'out'); box off; colorbar

figure(3)
imagesc(A{1}.xvec, 1:numUsableSessions, hmat_R12_zscore_peaksorted) %R12trialsAvgOverSession
% imagesc(A{1}.xvec, 1:numUsableSessions, normalized_hmat) % normalized_hmat

title(...
   'z-scored heatmap of average firing rate for 12 uL trials within each session; sorted by peak onset')
colormap default
caxis([-6, 4])
xlabel('time (s)')
ylabel('session')
set(gca,'fontsize',13)
set(gca, 'TickDir', 'out'); box off; colorbar

figure(4)
imagesc(A{1}.xvec, 1:numUsableSessions, hmat_R24_zscore_peaksorted) %R24trialsAvgOverSession
% imagesc(A{1}.xvec, 1:numUsableSessions, normalized_hmat) % normalized_hmat

title(...
   'z-scored heatmap of average firing rate for 24 uL trials within each session; sorted by peak onset')
colormap default
caxis([-6, 4])
xlabel('time (s)')
ylabel('session')
set(gca,'fontsize',13)
set(gca, 'TickDir', 'out'); box off; colorbar


figure(5)
imagesc(A{1}.xvec, 1:numUsableSessions, hmat_R48_zscore_peaksorted) %R48trialsAvgOverSession
% imagesc(A{1}.xvec, 1:numUsableSessions, normalized_hmat) % normalized_hmat

title(...
   'z-scored heatmap of average firing rate for 48 uL trials within each session; sorted by peak onset')
colormap default
caxis([-6, 4])
xlabel('time (s)')
ylabel('session')
set(gca,'fontsize',13)
set(gca, 'TickDir', 'out'); box off; colorbar

