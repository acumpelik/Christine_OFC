dt = 0.001;
[xvec,spikes_binned] = binspikes(spiketimes, handles, "start",dt,-2,4,2);
%% find (distribution of) spiking probability
% first find the mean probability
uniqueVals = unique(unique(spikes_binned)); % 0 and 1
% mean(spikes_binned, 'all')
meanSpikingProb = mean(reshape(spikes_binned, 1, [])); % flattened matrix into vector

%% find where in the bins the clicks occurred
clickDur = 0.003;
clickStart = cellfun(@min, handles.lbups) - handles.start;
clickEnd = cellfun(@max, handles.lbups) + clickDur - handles.start;
%%
% calculate the probability of spiking given stimulus presence
binnedSpikesStimPresent = {};
numTrials = length(handles.start);
startInds = discretize(clickStart, [xvec, xvec(end)+dt]);
endInds = discretize(clickEnd, [xvec, xvec(end)+dt]);
binnedSpikesStimPresent_vec = [];
for trial = 1:numTrials
    binnedSpikesStimPresent{trial} = spikes_binned(startInds(trial):endInds(trial));
    %concatenate each trial in a long vector
    binnedSpikesStimPresent_vec = [binnedSpikesStimPresent_vec,binnedSpikesStimPresent{trial}];
end

meanSpikingProbStimPresent = mean(binnedSpikesStimPresent_vec);

%%
meanSpikingProbR6 = [];
meanSpikingProbR12 = [];
meanSpikingProbR24 = [];
meanSpikingProbR48 = [];

spikesR6 = [];
spikesR12 = [];
spikesR24 = [];
spikesR48 = [];

[~, chosenval, ~, ~] = parse_choices(S);
for trial = 1:numTrials
    if chosenval(trial)==6
        spikesR6 = [spikesR6, binnedSpikesStimPresent{trial}];
    elseif chosenval(trial)==12
        spikesR12 = [spikesR12, binnedSpikesStimPresent{trial}];
    elseif chosenval(trial)==24
        spikesR24 = [spikesR24, binnedSpikesStimPresent{trial}];
    elseif chosenval(trial)==48
        spikesR48 = [spikesR48, binnedSpikesStimPresent{trial}];
    end
end

meanSpikingProbR6 = mean(spikesR6);
meanSpikingProbR12 = mean(spikesR12);
meanSpikingProbR24 = mean(spikesR24);
meanSpikingProbR48 = mean(spikesR48);