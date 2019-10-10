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
    yind = discretize(spikesStim,binEdges);             % find indices of spikes
    for m = 1:numBins
        spikesBinned(ii,m) = sum(numel(spikesStim(yind==m)));
    end
end

% % verify that bins only have 0 or 1 spikes
% unique(spikesBinned)

numSpikesPerTrial = sum(spikesBinned, 2);

%% find only trials where the animal was rewarded n uL
[~, chosenval, ~, ~, ~] = parse_choices(S);

% 6 uL
vol = 6;
rewardMask6 = chosenval==vol;
spikesBinned(rewardMask6);
spikeTrains6 = spikesBinned(rewardMask6, :);
% test: count spikes in each trial
sum(spikeTrains6, 2)

% % 12 uL
% vol = 12;
% rewardMask12 = chosenval==vol;
% spikesBinned(rewardMask12);
% spikeTrains12 = spikesBinned(rewardMask12, :);
% % test: count spikes in each trial
% sum(spikeTrains12, 2)

% % 24 uL
% vol = 24;
% rewardMask24 = chosenval==vol;
% spikesBinned(rewardMask24);
% spikeTrains24 = spikesBinned(rewardMask24, :);
% % test: count spikes in each trial
% sum(spikeTrains24, 2)

% % 48 uL
% vol = 48;
% rewardMask48 = chosenval==vol;
% spikesBinned(rewardMask48);
% spikeTrains48 = spikesBinned(rewardMask48, :);
% % test: count spikes in each trial
% sum(spikeTrains48, 2)

hmat = hmat_start; % which trial component we're aligning to

% run heatmap, hmat_start, generate PSTH for sessions of a certain volume
figure;
imagesc(spikeTrains6); % imagesc = image with scaled colors
title(strcat(['Raster plot for cell #', num2str(session), '. Trials with reward volume = 6 uL']));
set(gca, 'TickDir', 'out'); box off; colorbar % gca: current axes for chart; set tick direction to be outside

%% 
date = char(datetime('now', 'Format', 'MMddyyyy_HHmmss'));
                                            % create a timestamp so Matlab doesn't overwrite figures
filename = strcat(['Heatmap_session', num2str(session), '_rewardvolume6_', date]);
                                            % concatenate file name
savefig(filename)                           % save as .fig

saveas(gcf, filename, 'jpeg')               % save as .jpg


