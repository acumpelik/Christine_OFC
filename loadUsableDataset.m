% this script will import the OFC dataset and filter sessions based on various criteria
% it will also incorporate the first for loop from find_avgfr.m

% load David's concatenated data set
a = load('concatdata_ofc_start.mat');
A = a.A; % cell array with 1881 sessions

% count all sessions, and define a mask for counting sessions filtered according to my parameters
numSessionsTotal = numel(A);                % number of all sessions
usableVec = zeros(numel(A),1);              % logical of usable sessions (fire more than 2x/trial)
                                            % mean firing rate >= 0.5)

[fnames, units, ~, ~, rats] = getfnames;    % get the filenames from the excel sheet
                                            % determine parameters such as rat, if multiunit

% filter sessions for usability and other the things I want
for j = 1:numSessionsTotal                   
    % can add more filtering here
    if A{j}.isUsable && strcmp(units{j}(1), 's')==true
        usableVec(j) = 1;
    end
end
numUsableSessions = sum(usableVec);            % count number of usable sessions
