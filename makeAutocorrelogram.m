%% 1. ACG by trial - bin each trial
% based on binspikes.m

% % select a trial that has several spikes in it
% trialStart = handles.start(439);
% trialEnd = handles.end(439);

%%%%%% PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dt = 0.001;                                         % bin size in s
wndw = 1;                                           % window before and after trial
tmin = -1;                                          % bin start
tmax = 4;                                           % bin end

numTrials = length(handles.start);                  % number of trials
xvec = tmin:dt:tmax;                                % bins
numBins = numel(xvec);                              % number of bins
spikesBinned = zeros(numTrials,numBins);            % define a vector
alignHandle = handles.start;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for trial = 1:numTrials                            % loop through all the trials
    if isfield(handles, 'end')              % does the trial have a handles.end
        these = spiketimes>=handles.start(trial)-wndw & spiketimes<=handles.end(trial)+wndw;
                                            % a logical that finds spike indices for this trial in spiketimes
                                            
        spikesTrial = spiketimes(these) - alignHandle(trial);
                                            % find the actual spike time(s)and subtract trial start
%         spikes_binned(trial,:) = spikesTrial;
                                            % assign to our matrix with binned spikes
    else                                    % leavecpoke instead of end
        these = find(spiketimes>=handles.start(trial)-wndw_l & spiketimes<=handles.leavecpoke(trial)+wndw_r);
        spikesTrial = spikestimes(these)-alignHandle(trial);
%         spikes_binned(trial,:) = spikesTrial;
    end
    binedges = [xvec,xvec(end)+dt];
                                            % define the bin edges
    yind = discretize(spikesTrial,binedges);
                                            % find indices of spikes
    
    for m = 1:numBins
        spikesBinned(trial,m) = sum(numel(spikesTrial(yind==m)));
    end
    
end
%% Compute autocorrelogram and plot

cross = zeros(numTrials,numBins*2+1);
for trial=1:numTrials
    [cross(trial,:), lags] = xcorr(spikesBinned(trial,:), numBins);
    %cross = cross+cross;
end
    
stem(lags,sum(cross,1))

xlim([1,numBins])

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












