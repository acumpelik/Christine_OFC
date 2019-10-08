% this will count how many infinity sessions there are
% dependencies: find_avgfr.m, loadSession.m
% requires running find_avgfr.m first

sessionInfs = cell(numSessions, 1);             % row is session, each cell will contain a vector
                                                % named infTrials, a logical that finds infs in trials

for session = 1:numSessions
    loadSession
    numTrials = length(handles.start);          % the number of trials
    trialInfs = zeros(numTrials, 1);            % a logical of length numTrials that returns 1 if inf
                                                % and zero otherwise
    for trial = 1:numTrials
        trialTime = handles.end(trial)-handles.start(trial);
        trialInfs(trial, 1) = trialTime==0;
    end
    sessionInfs{session, 1} = [trialInfs];
end

%%
counttInfs = zeros(length(sessionInfs), 1);

for jj = 1:length(sessionInfs)
    numInf = sum(sum(sessionInfs{jj}));
    counttInfs(jj) = numInf;
end

% sum([sessionInfs{1:11}]) % only works if cell lengths are the same

%% plot
pie(histcounts(counttInfs), '0', '1', '2', '3')


