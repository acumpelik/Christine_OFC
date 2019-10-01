%% bin each trial
% based on binspikes.m

% % select a trial that has several spikes in it
% trialStart = handles.start(439);
% trialEnd = handles.end(439);

dt = 0.001; % bin size in s
wndw = 1;
tmin = -1;
tmax = 4;

numTrials = length(handles.start);
xvec = tmin:dt:tmax;
numBins = numel(xvec);
spikesBinned = zeros(numTrials,numBins);
alignHandle = handles.start;

for trial = 1:numTrials                            % loop through all the trials
    if isfield(handles, 'end')              % ********** I don't understand this
        these = spiketimes>=handles.start(trial)-wndw & spiketimes<=handles.end(trial)+wndw;
                                            % a logical that finds spike indices for this trial in spiketimes
                                            
        spikesTrial = spiketimes(these) - alignHandle(trial);
                                            % find the actual spike time(s)and subtract trial start
%         spikes_binned(trial,:) = spikesTrial;
                                            % assign to our matrix with binned spikes
    else
        these = find(spiketimes>=handles.start(trial)-wndw_l & spiketimes<=handles.leavecpoke(trial)+wndw_r);
        spikesTrial = spikestimes(these)-alignHandle(trial);
%         spikes_binned(trial,:) = spikesTrial;
    end
    binedges = [xvec,xvec(end)+dt];
                                            % define the bin edges
    yind = discretize(spikesTrial,binedges);
                                            % ************ a little unclear on this
    
    for m = 1:numBins
        spikesBinned(trial,m) = sum(numel(spikesTrial(yind==m)));
    end
    
end
%% Compute autocorrelogram and plot
[cross, lags] = xcorr(spikesBinned(439,:));
stem(cross)
% stem(lags)

%% 
% binnedData = discretize(spiketimes, bins);
these = find(spiketimes>=trialStart-wndw & spiketimes<=trialEnd+wndw);

%%

% try larger bins
dt = 0.1; % bin size in s
wndw = 1;
startTime = spiketimes(1);
tmin = spiketimes(1) - startTime;           % reset the start time to 0
tmax = spiketimes(500) - startTime;         % choose first n spikes

bins = tmin:dt:tmax;                        % formerly xvec
numBins = numel(bins);                      % number of bins
binedges = [bins,bins(end)+dt];
spktimes0 = spiketimes - startTime;  % make spiketimes start at 0
yind = discretize(spiketimes,binedges);

for m = 1:numBins
    spikesBinned(m) = sum(numel(spktimes0(yind==m)));
end

%%
acg = flipud(spikesBinned);
[cross, lags] = xcorr(acg);
stem(cross)












