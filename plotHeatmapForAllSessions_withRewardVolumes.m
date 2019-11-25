%% generate heatmap of all rewarded session
loadUsableDataset

% first define a heatmap mask with filtered (usable) sessions
hmat_usable = zeros(numUsableSessions,numel(A{1}.xvec));

% loop over each session, and add PSTH to hmat;
usableInds = find(usableVec);               % indices of usable sessions
avgSpikesPerSession = zeros(numUsableSessions,1); % define mask for avg # of spikes per session
for j = 1:numUsableSessions
    if  A{usableInds(j)}.isUsable           % if session is usable, grab correct index
     hmat_usable(j,:) = nanmean( A{usableInds(j)}.hmat,1 ); % binned spikes for usable sessions
    end
    
    % average number (over trials) of spikes for each session.
    % can change to firing rate if you want, would need to make sure time
    % corresponds to when those spikes counts were taken
    avgSpikesPerSession(j) = nanmean(A{usableInds(j)}.nspikes);
end

%% normalize (z-score) heatmap and plot
% order the data
[sessionsByNumSpikes,indicesAvgNumSpikes] = sort(avgSpikesPerSession);
hmat_sess_sorted = hmat_usable(indicesAvgNumSpikes,:);

% z-score
avgFR_allsessions = mean(hmat_sess_sorted, 2);  % find mean of hmat_sess_sorted rows
std_allsessions = std(hmat_sess_sorted, 0, 2);  % find STD of hmat_sess_sorted rows; w = 0 (default)
normalized_hmat = (hmat_sess_sorted - avgFR_allsessions) ./ std_allsessions;

%%
% arrange by peak onset
peakrange_min = 21; %first time bin to look for the peak
peakrange_max = 61; %last time bin to look for the peak

peaktime = zeros(1,numUsableSessions);
for j = 1:numUsableSessions
    [peakmax,pind] = max(normalized_hmat(j,peakrange_min:peakrange_max));
    peaktime(j) = A{1}.xvec(pind);
end

[B_pmax,I_pmax] = sort(peaktime);
hmat_sess_zscore_peaksorted = normalized_hmat(I_pmax,:);
hmat_sess_peaksorted = hmat_sess_sorted(I_pmax,:);
%%
% plot
imagesc(A{1}.xvec, 1:numUsableSessions, hmat_sess_zscore_peaksorted) % normalized_hmat
title('z-scored heatmap of average firing rate for each session; aligned to trial start')
colormap default
caxis([-6, 4])
xlabel('time (s)')
ylabel('session')
set(gca,'fontsize',13)
set(gca, 'TickDir', 'out'); box off; colorbar
