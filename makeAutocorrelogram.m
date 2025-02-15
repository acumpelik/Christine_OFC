%% ACG by trial - bin each trial

% first run loadSession.m

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
    binEdges = [xvec,xvec(end)+dt];
                                            % define the bin edges
    yind = discretize(spikesTrial,binEdges);
                                            % find indices of spikes
    
    for m = 1:numBins
        spikesBinned(trial,m) = sum(numel(spikesTrial(yind==m)));
    end
    
end
%% compute autocorrelogram

cross = zeros(numTrials,numBins*2+1);       % define a matrix for xcorr of binned data (x2) for each trial
                                            % plus 1 because you include the 0 point
for trial=1:numTrials
    [cross(trial,:), lags] = xcorr(spikesBinned(trial,:), numBins);
                                            % for each trial compute the autocorrelogram
                                            % (numBins is normalization I think?)
end

sumcross = sum(cross,1);                    % sum ACG across all trials
sumcrossNew = sumcross;
sumcrossNew(5002) = 0;                      % get rid of the middle value, which is essentially an artifact

closeup = sumcrossNew(4952:5052);
closeup_lags = lags(4952:5052);

%% plot
% figure
% ACG = bar(closeup_lags, closeup);
% title(['#', num2str(session)]) % I should make the FR not hard-coded
% xlabel('time (ms)')
% ylabel('correlation')
% xlim([-50 50])

%% save as .fig and .jpg
% date = char(datetime('now', 'Format', 'MMddyyyy_HHmmss'));
%                                             % create a timestamp so Matlab doesn't overwrite figures
% filename = strcat(['ACG_', num2str(session), '_', date]);
%                                             % concatenate file name
% savefig(filename)                           % save as .fig
% 
% saveas(gcf, filename, 'jpeg')               % save as .jpg

%% ACG across all trials












