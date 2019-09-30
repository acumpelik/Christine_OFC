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

%% based on binspikes.m
trialStart = handles.start(6);
trialEnd = handles.end(6);

% numTrials = length(handles.start); % number of trials
% dt = 0.001; % bin size in s
% tmin = trialStart - trialStart;
% tmax = trialEnd - trialStart;
% xvec = tmin:dt:tmax;
% numx = numel(xvec);
% spikes_binned = zeros(numTrials,numx);
wndw = 1;
tmin = -1;
tmax = 4;

nt = length(handles.start);
xvec = tmin:dt:tmax;
nx = numel(xvec);
spikes_binned = zeros(nt,nx);
alignHandle = handles.start;

for trial = 1:nt
    if isfield(handles, 'end')
        these = spiketimes>=handles.start(trial)-wndw & spiketimes<=handles.end(trial)+wndw;
        % does wndw have to be 1 second or the timestamp of the window?

        spikesTrial = spiketimes(these) - alignHandle(trial);
%         spikes_binned(trial,:) = spikesTrial;
    else
        these = find(spiketimes>=handles.start(trial)-wndw_l & spiketimes<=handles.leavecpoke(trial)+wndw_r);
        spikesTrial = spikestimes(these)-alignHandle(trial);
%         spikes_binned(trial,:) = spikesTrial;
    end
    
    %sort into bins, aligned to a specific event
    binedges = [xvec,xvec(end)+dt];
    yind = discretize(spikesTrial,binedges);
    
    for m = 1:nx
        spikes_binned(trial,m) = sum(numel(spikesTrial(yind==m)));
    end
    
end
%%

cross = xcorr(spikes_binned(:,6));
stem(cross)


