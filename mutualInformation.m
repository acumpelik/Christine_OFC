%% load session and find trials where each reward volume was presented
session = 741;
loadSession
numTrials = length(hmat_start);

leftVol = S.pd{1, 1}.this_left_volume;
% unique(leftVol)

trialsVol6 =  find(leftVol==6);
trialsVol12 = find(leftVol==12);
trialsVol24 = find(leftVol==24);
trialsVol48 = find(leftVol==48);

%% find spike probability given reward volume P(X|Y)
% bin spikes in a way that each bin has only 0 or 1 spikes

dt = 0.0005;                                             % bin size in s
wndw = 1;

for ii = 1:numTrials
    startTime = handles.lbups{ii}(1);
    endTime = handles.lbups{ii}(end);
    these = find(spiketimes>=startTime & spiketimes<=endTime);
    spikesStim = spiketimes(these);

%     totalTime = endTime - startTime; probbaly don't need
    xvec = startTime:dt:endTime;                        % bins
    numBins = numel(xvec);                              % number of bins
    binEdges = [xvec,xvec(end)+dt];                     % define the bin edges
    yind = discretize(spikesStim,binEdges);            % find indices of spikes
    for m = 1:numBins
        spikesBinned(ii,m) = sum(numel(spikesStim(yind==m)));
    end
end

% % verify that bins only have 0 or 1 spikes
% unique(spikesBinned)

numSpikesPerTrial = sum(spikesBinned, 2);

%% find only trials where the animal was rewarded 24 uL
[~, chosenval, ~, ~, ~] = parse_choices(S);
rewardMask24 = chosenval==24;
spikesBinned(rewardMask24);
spikeTrains24 = spikesBinned(rewardMask24, :);

% test: count spikes in each trial
sum(spikeTrains24, 2)


% run heatmap, hmat_start, generate PSTH for sessions of a certain volume
figure;
plot(xvec, nanmean(hmat(prev_hit==1 & ~isnan(hits),:)), 'b'); hold on 
plot(xvec, nanmean(hmat(prev_hit==0 & ~isnan(hits),:)), 'k');
set(gca, 'TickDir', 'out'); box off;
xlabel('Time from cpoke (s)');




