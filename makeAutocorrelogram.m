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
bins = 0:0.001:5; % set to one ms
binnedData = discretize(spiketimes, bins)


%% toy plot

x = [1 0 1 0 1];
[f, flags] = xcorr(x);
stem(flags, f)





