%% generate heatmap of all rewarded session
loadUsableDataset

% first define a heatmap mask with filtered (usable) sessions; R24 trials averaged over session
usableInds = find(usableVec);               % indices of usable sessions
R24trialsAvgOverSession = zeros(numUsableSessions, length(A{1}.xvec));
avgSpikesPerSession = zeros(numUsableSessions,1); % define mask for avg # of spikes per session

% loop over each session, find R24 trials, average them and add avg to hmat;
for session = 1:numUsableSessions
    if  A{usableInds(session)}.isUsable           % if session is usable, grab correct index
     
     % filter out trials with 24uL
     R24trialsMask = A{usableInds(session)}.chosenval==24; % logical with trials where rat gets 24uL
     numR24trials = sum(R24trialsMask); % count 24uL trials
     R24trialInds = find(R24trialsMask); % find 24uL indices
     R24trials = zeros(numR24trials, length(A{1}.xvec)); % designate matrix with 24uL trials for session
         for trial = 1:numR24trials
             % copy avg FR for 24uL trial
             R24trials(trial, :) = A{usableInds(session)}.hmat(R24trialInds(trial), :);
         end
%      sessionAvg(session, :) = mean(R24trials);
    end
    
    % average trials from this session and add to main heatmap
    R24trialsAvgOverSession(session, :) = mean(R24trials);
    avgSpikesPerSession(session) = nanmean(A{usableInds(session)}.nspikes);
end

% % plot R24 trials for a single session (not averaged)
% imagesc(A{1}.xvec, 1:numR24trials, R24trials)

%% normalize (z-score) heatmap and plot
% order the data
[sessionsByNumSpikes,indicesAvgNumSpikes] = sort(avgSpikesPerSession);
hmat_sorted = R24trialsAvgOverSession(indicesAvgNumSpikes, :);

% z-score
avgFR_allsessions = mean(hmat_sorted, 2);  % find mean of hmat_sess_sorted rows
std_allsessions = std(hmat_sorted, 0, 2);  % find STD of hmat_sess_sorted rows; w = 0 (default)
normalized_hmat = (hmat_sorted- avgFR_allsessions) ./ std_allsessions;

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
hmat_sess_zscore_peaksorted = normalized_hmat(I_pmax,:);
hmat_sess_peaksorted = hmat_sorted(I_pmax,:);
%%
% plot
imagesc(A{1}.xvec, 1:numUsableSessions, hmat_sess_zscore_peaksorted) %R24trialsAvgOverSession
% imagesc(A{1}.xvec, 1:numUsableSessions, normalized_hmat) % normalized_hmat

title(...
   'z-scored heatmap of average firing rate for 24 uL trials within each session; sorted by peak onset')
colormap default
caxis([-6, 4])
xlabel('time (s)')
ylabel('session')
set(gca,'fontsize',13)
set(gca, 'TickDir', 'out'); box off; colorbar
