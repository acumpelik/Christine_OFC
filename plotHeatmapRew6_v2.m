%% generate heatmap of all rewarded session
loadUsableDataset

% first define a heatmap mask with filtered (usable) sessions
hmat_usable = zeros(numUsableSessions,numel(A{1}.xvec));

% loop over each session, find R6 trials, average them and add avg to hmat;
usableInds = find(usableVec);               % indices of usable sessions
R6trialsAvgOverSession = zeros(numUsableSessions, length(A{1}.xvec));
    % define mask for R6 trials averaged over session
for session = 1:numUsableSessions
    if  A{usableInds(session)}.isUsable           % if session is usable, grab correct index
%      hmat_usable(session,:) = nanmean( A{usableInds(session)}.hmat,1 ); % binned spks for usable sess.
     
     % filter out trials with 6uL
     R6trialsMask = A{usableInds(session)}.chosenval==6; % logical with trials where rat gets 6uL
     numR6trials = sum(R6trialsMask); % count 6uL trials
     R6trialInds = find(R6trialsMask); % find 6uL indices
     R6trials = zeros(numR6trials, length(A{1}.xvec)); % designate matrix with 6uL trials for session
         for trial = 1:numR6trials
             R6trials(trial, :) = A{session}.hmat(R6trialInds(trial), :); % copy avg FR for 6uL trial
         end
     sessionAvg(session, :) = mean(R6trials);
    end
    R6trialsAvgOverSession(session, :) = mean(R6trials);
%     % average number (over trials) of spikes for each session.
%     % can change to firing rate if you want, would need to make sure time
%     % corresponds to when those spikes counts were taken
%     avgSpikesPerSession(j) = nanmean(A{usableInds(j)}.nspikes);
end

% % plot R6 trials for a single session (not averaged)
% imagesc(A{1}.xvec, 1:numR6trials, R6trials)

%%





%% normalize (z-score) heatmap and plot
% % order the data
% [sessionsByNumSpikes,indicesAvgNumSpikes] = sort(R6trialsAvgOverSession);
% hmat_sess_sorted = hmat_usable(indicesAvgNumSpikes,:);
% 
% % z-score
% avgFR_allsessions = mean(hmat_sess_sorted, 2);  % find mean of hmat_sess_sorted rows
% std_allsessions = std(hmat_sess_sorted, 0, 2);  % find STD of hmat_sess_sorted rows; w = 0 (default)
% normalized_hmat = (hmat_sess_sorted - avgFR_allsessions) ./ std_allsessions;
% 
% %%
% % arrange by peak onset
% peakrange_min = 21; %first time bin to look for the peak
% peakrange_max = 61; %last time bin to look for the peak
% 
% peaktime = zeros(1,numUsableSessions);
% for session = 1:numUsableSessions
%     [peakmax,pind] = max(normalized_hmat(session,peakrange_min:peakrange_max));
%     peaktime(session) = A{1}.xvec(pind);
% end
% 
% [B_pmax,I_pmax] = sort(peaktime);
% hmat_sess_zscore_peaksorted = normalized_hmat(I_pmax,:);
% hmat_sess_peaksorted = hmat_sess_sorted(I_pmax,:);
%%
% plot
imagesc(A{1}.xvec, 1:numUsableSessions, R6trialsAvgOverSession) % normalized_hmat
title('z-scored heatmap of average firing rate for each session; aligned to trial start')
colormap default
xlabel('time (s)')
ylabel('session')
set(gca,'fontsize',13)
set(gca, 'TickDir', 'out'); box off; colorbar
