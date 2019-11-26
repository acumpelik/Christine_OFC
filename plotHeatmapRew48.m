%% generate heatmap of all rewarded session
loadUsableDataset

% first define a heatmap mask with filtered (usable) sessions; R48 trials averaged over session
usableInds = find(usableVec);               % indices of usable sessions
hmat_R48 = zeros(numUsableSessions, length(A{1}.xvec));
avgSpikesPerSession = zeros(numUsableSessions,1); % define mask for avg # of spikes per session

% loop over each session, find R48 trials, average them and add avg to hmat;
for session = 1:numUsableSessions
    if  A{usableInds(session)}.isUsable           % if session is usable, grab correct index
     
     % filter out trials with 48uL
     R48trialsMask = A{usableInds(session)}.chosenval==48; % logical with trials where rat gets 48uL
     numR48trials = sum(R48trialsMask); % count 48uL trials
     R48trialInds = find(R48trialsMask); % find 48uL indices
     R48trials = zeros(numR48trials, length(A{1}.xvec)); % designate matrix with 48uL trials for session
         for trial = 1:numR48trials
             % copy avg FR for 48uL trial
             R48trials(trial, :) = A{usableInds(session)}.hmat(R48trialInds(trial), :);
         end
%      sessionAvg(session, :) = mean(R48trials);
    end
    
    % average trials from this session and add to main heatmap
    hmat_R48(session, :) = mean(R48trials);
    avgSpikesPerSession(session) = nanmean(A{usableInds(session)}.nspikes);
end

% % plot R48 trials for a single session (not averaged)
% imagesc(A{1}.xvec, 1:numR48trials, R48trials)

%% normalize (z-score) heatmap and plot
% order the data
[sessionsByNumSpikes,indicesAvgNumSpikes] = sort(avgSpikesPerSession);
hmat_sorted = hmat_R48(indicesAvgNumSpikes, :);

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
imagesc(A{1}.xvec, 1:numUsableSessions, hmat_sess_zscore_peaksorted) %R48trialsAvgOverSession
% imagesc(A{1}.xvec, 1:numUsableSessions, normalized_hmat) % normalized_hmat

title(...
   'z-scored heatmap of average firing rate for 48 uL trials within each session; sorted by peak onset')
colormap default
caxis([-6, 4])
xlabel('time (s)')
ylabel('session')
set(gca,'fontsize',13)
set(gca, 'TickDir', 'out'); box off; colorbar
