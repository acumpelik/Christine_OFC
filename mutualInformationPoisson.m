[fnames, units, ~, ~, rats] = getfnames;
numSessions = length(fnames);
mutualInformation = zeros(numSessions, 1);
for session = 1:10 %numSessions
    load(strcat(['C:\Christine_data\parsed_data', filesep, fnames{session}, '.mat']))
    
    dt = 0.001;
    [xvec,spikes_binned] = binspikes(spiketimes, handles, "start",dt,-2,4,2);
    %% find (distribution of) spiking probability
    % first find the mean probability
%     uniqueVals = unique(unique(spikes_binned)); % 0 and 1
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
    H_spikingStimPresent = -meanSpikingProbStimPresent * log(meanSpikingProbStimPresent) - ...
        (1-meanSpikingProbStimPresent)*log(1-meanSpikingProbStimPresent);
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

    %% calculate entropy: binary entropy function
    % 1. conditional expectation
    conditionalExpectation = zeros(4, 1);
    meanSpikingProbVolumes = [meanSpikingProbR6, meanSpikingProbR12, meanSpikingProbR24, meanSpikingProbR48];
    for volume = 1:4
        p_v = meanSpikingProbVolumes(volume);
        conditionalExpectation(volume) = -p_v * log(p_v) - (1-p_v)*log(1-p_v);
    end
    %%
    % 2. conditional entropy
    pRvol = 0.25; % probability that the reward equals any of the four volumes (approximated)
    conditionalEntropy = zeros(4, 1);
    for volume = 1:4
        conditionalEntropy(volume) = conditionalExpectation(volume);
    end
    %%
    % 3. mutual information
    conditionalEntropy = (meanSpikingProbVolumes * pRvol) * conditionalExpectation;
    mutualInformation(session) = H_spikingStimPresent - conditionalEntropy;
end

%%
% plot(sort(mutualInformation))
mutualInformationNewLogical = ~isnan(mutualInformation);
mutualInformationNew = mutualInformation(mutualInformationNewLogical);
[mutualInformationSorted, mutualInformationSortedInds] = sort(mutualInformationNew);
plot(sort(mutualInformationNew))
title('Mutual information across all neurons')
xlabel('Session (neuron) #')
ylabel('Mutual information (bits)')

% NOTES
% plot mutual information on log scale
% does this change qualitatively on error trials?
% other stimulus dimensions: probability? have stimulus as multidimensional: reward x probability
% 


