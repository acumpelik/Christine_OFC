clear;clc
importDataset
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
% help

% plot(A{1}.xvec, hmat_R6(1,:));
% imagesc(A{1}.xvec, 1:R6mask, hmat_R6)
imagesc(A{1}.xvec, 1:R6mask, hmat_R6(1:100,:))




