% Step 0: load spike train
% spikeTrain = spiketimes

% Step 1: bin spikes
binlength = 0.001; % in seconds
numBins = int64(length(spiketimes)/binlength); % this is wrong, not duration of trial
[bins, binEdge] = discretize(spiketimes, numBins);


% Step 2: use xcorr, plot using imagesc / surf methods
% [xc,lags] = xcorr(bins,'coeff');
[xc, lags] = xcorr(spiketimes, 'coeff');
stem(lags,xc)

histogram(lags)

imagesc(lags)

%%

% Step 1: bin the data into 1 ms bins

trialStart = handles.start(6);
trialEnd = handles.end(6);
% wndw = 1;
bins = trialStart:0.001:trialEnd+5; % 1 ms increments

% bins = spiketimes(end)

binnedData = discretize(spiketimes, bins);
these = find(spiketimes>=trialStart-wndw & spiketimes<=trialEnd+wndw);


% [cross, lags] = xcorr

%% toy plot

x = [1 0 1 0 1];
[f, flags] = xcorr(x);
stem(flags, f)





