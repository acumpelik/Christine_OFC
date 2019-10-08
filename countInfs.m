% this will count how many infinity sessions there are
% dependencies: find_avgfr.m, loadSession.m
% requires running find_avgfr.m first

sessionInfs = cell(numSessions, 1);             % row is session, column is a logical that finds infs in trials


for ii = 1:numSessions
    disp(ii)
    session = ii;
    loadSession
    numTrials = length(handles.start);
    trialTimes = zeros(numTrials, 1);
    trialInfs = zeros(numTrials, 1);
    for trial = 1:numTrials
        trialTimes(trial) = handles.end(trial)-handles.start(trial);
        trialInfs(trial) = trialTimes(trial)==0;
    end
    sessionInfs{ii, 1} = [trialInfs];
end

%%
counttInfs = zeros(length(sessionInfs), 1);
jj = 0;
num = 0;
for jj = 1:length(sessionInfs)
    numInf = sum(sum(sessionInfs{jj}));
    num = numInf+num;
    disp(num)
%     counttInfs(jj) = num;
end




