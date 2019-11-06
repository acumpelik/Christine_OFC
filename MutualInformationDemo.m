[xvec,spikes_binned] = binspikes(spiketimes, handles, "start",0.001,-2,4,2);
%% find (distribution of) spiking probability
% first find the mean probability
uniqueVals = unique(unique(spikes_binned)); % 0 and 1
% mean(spikes_binned, 'all')
meanSpikingProb = mean(reshape(spikes_binned, 1, [])); % flattened matrix into vector

%% find where in the bins the clicks occurred
clickDur = 0.003;