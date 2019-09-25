function n = nspikespertrials(spiketimes, handles, wndw)
%wndw is in seconds, refers to a window that follows the trial.

n = nan(length(handles.start), 1);

for j = 1:length(handles.start);
    if isfield(handles, 'end');
        these = find(spiketimes>=handles.start(j)-wndw & spiketimes<=handles.end(j)+wndw);
    else
        these = find(spiketimes>=handles.start(j)-wndw & spiketimes<=handles.leavecpoke(j)+wndw);
    end
    n(j) = numel(these);
end