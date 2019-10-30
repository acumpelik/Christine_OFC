%% plot heatmap of all session rewards

% moved code from here to importDataset.m

% define a heatmap mask with filtered sessions
hmat_usable = zeros(usableSessions,numel(A{1}.xvec));

% loop over each session, and PSTH add to hmat;
usableInds = find(usableVec);               % indices of usable sessions
avgSpikesPerSession = zeros(usableSessions,1); % define mask for avg # of spikes per session
for j = 1:usableSessions
    if  A{usableInds(j)}.isUsable           % if session is usable, grab correct index
     hmat_usable(j,:) = nanmean( A{usableInds(j)}.hmat,1 );
    end
    
    % average number (over trials) of spikes for each session
    % can change to firing rate if you want. would need to make sure time
    % corresponds to when those spikes counts were taken
    avgSpikesPerSession(j) = nanmean(A{usableInds(j)}.nspikes);
end


%% order the data
[sessionsByNumSpikes,indicesAvgNumSpikes] = sort(avgSpikesPerSession);
hmat_sess_sorted = hmat_usable(indicesAvgNumSpikes,:);

% surf(A{1}.xvec,1:usableSessions,hmat_sess_sorted)
imagesc(A{1}.xvec,1:usableSessions,hmat_sess_sorted)
colormap default
xlabel('time (s)')
ylabel('session')
set(gca,'fontsize',15)
set(gca, 'TickDir', 'out'); box off; colorbar

%% subset of high-firing data
% count only sessions that have B greater than 100
% variables are: sessionsByAvgFR, hmat_sess_sorted, indicesAvgFR

hmat_high_firing = zeros(sum(sessionsByNumSpikes>100), numel(A{1}.xvec));
num_high_firing_sessions = sum(sessionsByNumSpikes>100);

hmat_high_firing = hmat_sess_sorted(indicesAvgNumSpikes(sessionsByNumSpikes>100), :);
% imagesc(A{1}.xvec,1:usableSessions,hmat_sess_sorted)
imagesc(A{1}.xvec, 1:100, hmat_sess_sorted(end-100:end, :))
% imagesc(A{1}.xvec,1:sum(sessionsByNumSpikes>100),hmat_high_firing)
% 
% for 1:length(B)
%     if sessionsByAvgFR>100:
%         hma
%     end
% end

%% z-scored PSTH
% subtract the mean firing rate and normalize by STD

hmat_sess_sorted(end, :);                   % choose highest firing rate session
plot(A{1}.xvec, hmat_sess_sorted(end, :), 'k','linewidth',2)    % plot original PSTH

avgFR = mean(hmat_sess_sorted(end, :));     % find the session's avg firing rate
normalized_PSTH = hmat_sess_sorted(end, :) ./ avgFR;    % divide each bin by average firing rate

plot(A{1}.xvec, normalized_PSTH)            % plot z-scored PSTH

%% z-scored heatmap
avgFR_allsessions = mean(hmat_sess_sorted, 2);  % find mean of hmat_sess_sorted rows
std_allsessions = std(hmat_sess_sorted, 0, 2);  % find STD of hmat_sess_sorted rows; w = 0 (default)
normalized_hmat = (hmat_sess_sorted - avgFR_allsessions) ./ std_allsessions;

imagesc(A{1}.xvec, 1:usableSessions, normalized_hmat)
title('z-scored heatmap of firing rate for each session')
colormap default
xlabel('time (s)')
ylabel('session')
set(gca,'fontsize',15)
set(gca, 'TickDir', 'out'); box off; colorbar
