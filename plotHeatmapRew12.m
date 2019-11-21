%% generate heatmap of all rewarded session
loadUsableDataset

% first define a heatmap mask with filtered (usable) sessions; R12 trials averaged over session
usableInds = find(usableVec);               % indices of usable sessions
R12trialsAvgOverSession = zeros(numUsableSessions, length(A{1}.xvec));
avgSpikesPerSession = zeros(numUsableSessions,1); % define mask for avg # of spikes per session

% loop over each session, find R12 trials, average them and add avg to hmat;
for session = 1:numUsableSessions
    if  A{usableInds(session)}.isUsable           % if session is usable, grab correct index
     
     % filter out trials with 12uL
     R12trialsMask = A{usableInds(session)}.chosenval==12; % logical with trials where rat gets 12uL
     numR12trials = sum(R12trialsMask); % count 12uL trials
     R12trialInds = find(R12trialsMask); % find 12uL indices
     R12trials = zeros(numR12trials, length(A{1}.xvec)); % designate matrix with 12uL trials for session
         for trial = 1:numR12trials
             % copy avg FR for 12uL trial
             R12trials(trial, :) = A{usableInds(session)}.hmat(R12trialInds(trial), :);
         end
%      sessionAvg(session, :) = mean(R12trials);
    end
    
    % average trials from this session and add to main heatmap
    R12trialsAvgOverSession(session, :) = mean(R12trials);
    avgSpikesPerSession(session) = nanmean(A{usableInds(session)}.nspikes);
end

% % plot R12 trials for a single session (not averaged)
% imagesc(A{1}.xvec, 1:numR12trials, R12trials)

%% normalize (z-score) heatmap and plot
% order the data
[sessionsByNumSpikes,indicesAvgNumSpikes] = sort(avgSpikesPerSession);
hmat_sorted = R12trialsAvgOverSession(indicesAvgNumSpikes, :);

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
imagesc(A{1}.xvec, 1:numUsableSessions, hmat_sess_zscore_peaksorted) %R12trialsAvgOverSession
% imagesc(A{1}.xvec, 1:numUsableSessions, normalized_hmat) % normalized_hmat

title(...
   'z-scored heatmap of average firing rate for 12 uL trials within each session; sorted by peak onset')
colormap default
caxis([-6, 4])
xlabel('time (s)')
ylabel('session')
set(gca,'fontsize',13)
set(gca, 'TickDir', 'out'); box off; colorbar
