% this script will import the OFC dataset and filter sessions based on various criteria
% it will also incorporate the first for loop from find_avgfr.m

% load David's concatenated data set
a = load('concatdata_ofc_pokeend.mat');
A = a.A; % cell array with 1881 sessions

% count all sessions, and define a mask for counting sessions filtered according to my parameters
numSessionsTotal = numel(A);                % number of all sessions
usableVec = zeros(numel(A),1);              % logical of usable sessions (fire more than 2x/trial)
                                            % mean firing rate >= 0.5)

% filter sessions for usability and other the things I want
for j = 1:numSessionsTotal                   
    % can add more filtering here. you already code for it to remove MUA
    if A{j}.isUsable
        usableVec(j) = 1;
    end
end
usableSessions = sum(usableVec);            % count number of usable sessions
