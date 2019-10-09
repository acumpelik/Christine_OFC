%% load session and find trials where each reward volume was presented
session = 741;
loadSession

leftVol = S.pd{1, 1}.this_left_volume;
unique(leftVol)

trialsVol6 =  find(leftVol==6);
trialsVol12 = find(leftVol==12);
trialsVol24 = find(leftVol==24);
trialsVol48 = find(leftVol==48);

%% find spike probability given reward volume P(X|Y)
% bin spikes in a way that each bin has only 0 or 1 spikes

dt = 0.001;                                             % bin size in s

for ii = 1:numTrials
    startTime = handles.lbups{1}(1);
    endTime = handles.lbups{1}(end);
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
% unique(spikesBinned);