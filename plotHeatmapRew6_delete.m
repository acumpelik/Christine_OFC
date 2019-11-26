
hmat_R6 = zeros(numUsableSessions, length(A{1}.xvec));
avgSpikesPerSession_R6 = zeros(numUsableSessions,1); % define mask for avg # of spikes per session

% loop over each session, find R6 trials, average them and add avg to hmat;
for session = 1:numUsableSessions
    if  A{usableInds(session)}.isUsable           % if session is usable, grab correct index
     
     % filter out trials with 6uL
     R6trialsMask = A{usableInds(session)}.chosenval==6; % logical with trials where rat gets 6uL
     numR6trials = sum(R6trialsMask); % count 6uL trials
     R6trialInds = find(R6trialsMask); % find 6uL indices
     R6trials = zeros(numR6trials, length(A{1}.xvec)); % designate matrix with 6uL trials for session
         for trial = 1:numR6trials
             % copy avg FR for 6uL trial
             R6trials(trial, :) = A{usableInds(session)}.hmat(R6trialInds(trial), :);
         end
%      sessionAvg(session, :) = mean(R6trials);
    end
    
    % average trials from this session and add to main heatmap
    hmat_R6(session, :) = mean(R6trials);
    avgSpikesPerSession_R6(session) = nanmean(A{usableInds(session)}.nspikes);
end

% % plot R6 trials for a single session (not averaged)
% imagesc(A{1}.xvec, 1:numR6trials, R6trials)

%% normalize (z-score) heatmap and plot
% order the data
[sessionsByNumSpikes,indicesAvgNumSpikes] = sort(avgSpikesPerSession_R6);
hmat_sorted = hmat_R6(indicesAvgNumSpikes, :);

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
imagesc(A{1}.xvec, 1:numUsableSessions, hmat_sess_zscore_peaksorted) %R6trialsAvgOverSession
% imagesc(A{1}.xvec, 1:numUsableSessions, normalized_hmat) % normalized_hmat

title(...
    'z-scored heatmap of average firing rate for 6 uL trials within each session; sorted by peak onset')
colormap default
caxis([-6, 4])
xlabel('time (s)')
ylabel('session')
set(gca,'fontsize',13)
set(gca, 'TickDir', 'out'); box off; colorbar
