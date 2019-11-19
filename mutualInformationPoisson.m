[fnames, units, ~, ~, rats] = getfnames;
numSessions = length(fnames);
mutualInformation = zeros(numSessions, 1);
dt = 0.05;
k_max = 20;
Vvec = [6,12,24,48]; %volume rewards
nV = numel(Vvec);
H_Poiss = zeros(numSessions, 1);
H_CExp_Vol = zeros(numSessions,nV); %conditional expectation given reward volume (value)
H_CEnt_Vol = zeros(numSessions, 1); %conditional entropy given reward volume distribution
I_Vol = zeros(numSessions, 1); %mutual information given reward volume distribution
%%
for session = 3 %numSessions
    load(strcat(['C:\Christine_data\parsed_data', filesep, fnames{session}, '.mat']))
    [xvec,spikes_binned] = binspikes(spiketimes, handles, "start",dt,-2,4,2);
    [~, chosenval, hits, ~] = parse_choices(S);
    numTrials = length(handles.start);
    
    hitmask = ~isnan(hits);

    clickDur = 0.003;
    clickStart = cellfun(@min, handles.lbups) - handles.start;
    clickEnd = cellfun(@max, handles.lbups) + clickDur - handles.start;
    
    startInds = discretize(clickStart, [xvec_start, xvec_start(end)+dt]);
    endInds = discretize(clickEnd, [xvec_start, xvec_start(end)+dt]);
    
    % calculate lambda
    lambda = NaN(numTrials, 1);
    lambda_givenV = NaN(numTrials,nV); % lambdas for each trial, with column being reward volume
    for trial = 1:numTrials
        %marginalized over all reward volumes
        if hitmask(trial)
            lambda(trial) = nanmean(hmat_start(trial, startInds(trial):endInds(trial))); % mean of mean of rows (mean firing rate of all trials)
        end 
        %conditioned on partiuclar reward volumes
        if chosenval(trial)==6
            lambda_givenV(trial,1) = nanmean(hmat_start(trial, startInds(trial):endInds(trial)));
        elseif chosenval(trial)==12
            lambda_givenV(trial,2) = nanmean(hmat_start(trial, startInds(trial):endInds(trial)));
        elseif chosenval(trial)==24
            lambda_givenV(trial,3) = nanmean(hmat_start(trial, startInds(trial):endInds(trial)));
        elseif chosenval(trial)==48
            lambda_givenV(trial,4) = nanmean(hmat_start(trial, startInds(trial):endInds(trial)));
        end 
    end
    
    lambda_avg = nanmean(lambda);
    
        % find the entropy of the Poisson distribution
    H_Poiss(session) = lambda_avg * [1 - log(lambda_avg)] + exp(-lambda_avg) * ...
        [lambda_avg*k_max*log(factorial(k_max)) / factorial(k_max)];
    
    lambda_avg_givenV = zeros(nV, 1);
    lambda_avg_givenV(1) = nanmean(lambda_givenV(:, 1)); % R6
    lambda_avg_givenV(2) = nanmean(lambda_givenV(:, 2)); % R12
    lambda_avg_givenV(3) = nanmean(lambda_givenV(:, 3)); % R24
    lambda_avg_givenV(4) = nanmean(lambda_givenV(:, 4)); % R48
    
    
    pRvol = 0.25; % probability that the reward equals any of the four volumes (approximated)
    for rewVol = 1:nV
        % 1. find conditional expectation given reward volume
        H_CExp_Vol(session, rewVol) = lambda_avg_givenV(rewVol) * ...
            [1 - log(lambda_avg_givenV(rewVol))] + exp(-lambda_avg_givenV(rewVol)) * ...
            [lambda_avg_givenV(rewVol)*k_max*log(factorial(k_max)) / factorial(k_max)];
                % 2. find conditional entropy
    end

    H_CEnt_Vol(session) = sum(H_CExp_Vol(session, :)) * pRvol;

    % 3. find mutual information given a reward volume
    I_Vol(session) = H_Poiss(session) - H_CEnt_Vol(session);
    
    
% 
% 
%     %% calculate entropy: binary entropy function
%     
%     conditionalExpectation = zeros(4, 1);
%     meanSpikingProbVolumes = [meanSpikingProbR6, meanSpikingProbR12, meanSpikingProbR24, meanSpikingProbR48];
%     for volume = 1:4
%         p_v = meanSpikingProbVolumes(volume);
%         conditionalExpectation(volume) = -p_v * log(p_v) - (1-p_v)*log(1-p_v);
%     end
%     %%
%     % 2. conditional entropy
%     pRvol = 0.25; % probability that the reward equals any of the four volumes (approximated)
%     conditionalEntropy = zeros(4, 1);
%     for volume = 1:4
%         conditionalEntropy(volume) = conditionalExpectation(volume);
%     end
%     %%
%     % 3. mutual information
%     conditionalEntropy = (meanSpikingProbVolumes * pRvol) * conditionalExpectation;
%     mutualInformation(session) = H_spikingStimPresent - conditionalEntropy;
end

%%
% plot(sort(mutualInformation))
mutualInformationNewLogical = ~isnan(I_Vol);
mutualInformationNew = mutualInformation(mutualInformationNewLogical);
[mutualInformationSorted, mutualInformationSortedInds] = sort(mutualInformationNew);
plot(sort(mutualInformationNew))
title('Mutual information across all neurons')
xlabel('Session (neuron) #')
ylabel('Mutual information (bits)')



