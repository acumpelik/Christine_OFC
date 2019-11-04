importDataset

% find all trials where chosenval==6 and session is usable
% make a cell array with usable sessions, in each usable session's cell, find trials where chosenval==6
R6 = cell([numUsableSessions, 1]);                  % make a cell array with usable sessions
usableInds = find(usableVec);                       % find indices of usable sessions
% for each session, find trials where animal chose reward 6
for j = 1:numUsableSessions
    % here you just do the same thing you did with usable sessions


end
% hmat_usable = zeros(numUsableSessions,numel(A{1}.xvec));