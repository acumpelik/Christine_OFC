% clear;clc
loadUsableDataset
%% generate heatmap of all trials where the rat got 6 uL
% find all trials where chosenval==6 and session is usable
R6 = cell([numUsableSessions, 1]);                  % make a cell array with usable sessions
usableInds = find(usableVec);                       % find indices of usable sessions
% for each session, find trials where animal chose reward 6
for j = 1:numUsableSessions
    R6{j, 1} = A{usableInds(j)}.chosenval==6;       % make a logical where trial chosenval==6
end

R6mask = sum(cell2mat(R6));                         % number of trials where animal got 6 uL
hmat_R6 = zeros(R6mask, numel(A{1}.xvec));          % heatmap mask for trials where animal got 6 uL

% generate heatmap for each trial
for j = 1:numUsableSessions
    numTrials = length(A{j}.hmat);                  % count number of trials
    for k = 1:numTrials
        if A{j}.chosenval(k)==6
            hmat_R6(k,:) = nanmean( A{usableInds(j)}.hmat,1 );
        end
    end
end

%% order and plot the z-scored heatmap

% order the data
[~, meanPSTHindex] = sort(mean(hmat_R6,2), 'ascend');
hmat_R6_sorted = hmat_R6(meanPSTHindex, :);

avgFR_R6 = mean(hmat_R6_sorted, 2);  % find mean of hmat_sess_sorted rows
std_R6 = std(hmat_R6_sorted, 0, 2);  % find STD of hmat_sess_sorted rows; w = 0 (default)
normalized_hmat_R6 = (hmat_R6_sorted - avgFR_R6) ./ std_R6;


% plot(A{1}.xvec, hmat_R6(1:652,:));
imagesc(A{1}.xvec, 1:R6mask, normalized_hmat_R6)
% imagesc(A{1}.xvec, 1:R6mask, hmat_R6(1:100,:))

title('z-scored heatmap of firing rate for trials where rat got 6 uL')
colormap default
xlabel('time (s)')
ylabel('trial')
set(gca,'fontsize',15)
set(gca, 'TickDir', 'out'); box off; colorbar



