%% generate heatmap of all rewarded session
importDataset

% define a heatmap mask with filtered sessions
hmat_usable = zeros(numUsableSessions,numel(A{1}.xvec));

% loop over each session, find trials where reward vol == 6, and add PSTH to hmat;
usableInds = find(usableVec);               % indices of usable sessions
avgSpikesPerSession = zeros(numUsableSessions,1); % define mask for avg # of spikes per session
for j = 1:numUsableSessions
    [~, chosenval, hits, ~] = parse_choices(S);
    if  A{usableInds(j)}.isUsable           % if session is usable, grab correct index
        numTrials = length(A{j}.hmat);
        for k = 1:numTrials
            
     hmat_usable(j,:) = nanmean( A{usableInds(j)}.hmat,1 );
    end
    
    % average number (over trials) of spikes for each session.
    % can change to firing rate if you want, would need to make sure time
    % corresponds to when those spikes counts were taken
    avgSpikesPerSession(j) = nanmean(A{usableInds(j)}.nspikes);
end

%% z-score PSTH
% subtract the mean firing rate and normalize by std

hmat_sess_sorted(end, :);                   % choose highest firing rate session
plot(A{1}.xvec, hmat_sess_sorted(end, :), 'k','linewidth',2)    % plot original PSTH

avgFR = mean(hmat_sess_sorted(end, :));     % find the session's avg firing rate
normalized_PSTH = hmat_sess_sorted(end, :) ./ avgFR;    % divide each bin by average firing rate

plot(A{1}.xvec, normalized_PSTH)            % plot z-scored PSTH

%% plot z-scored heatmap
% order the data
[sessionsByNumSpikes,indicesAvgNumSpikes] = sort(avgSpikesPerSession);
hmat_sess_sorted = hmat_usable(indicesAvgNumSpikes,:);

avgFR_allsessions = mean(hmat_sess_sorted, 2);  % find mean of hmat_sess_sorted rows
std_allsessions = std(hmat_sess_sorted, 0, 2);  % find STD of hmat_sess_sorted rows; w = 0 (default)
normalized_hmat = (hmat_sess_sorted - avgFR_allsessions) ./ std_allsessions;

imagesc(A{1}.xvec, 1:numUsableSessions, normalized_hmat)
title('z-scored heatmap of firing rate for each session')
colormap default
xlabel('time (s)')
ylabel('session')
set(gca,'fontsize',15)
set(gca, 'TickDir', 'out'); box off; colorbar
