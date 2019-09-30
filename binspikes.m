% From David
function [xvec,spikes_binned] = binspikes(spiketimes, handles, alignment,dt,tmin,tmax,wndw)
%BINSPIKES put spikes into equalbins
%
%input:
%   spiketimes: long array of spike timings
%   
%   handles: handle of trial timings
%   
%   alignment: string handle for what event to be aligned
%   
%   dt: bin size (in s)
%   
%   tmin: first bin
%   
%   tmax: last bin
%   
%   wndw: time (in s) to extend from each side of tmin,tmax for spikes
%   if wndow if a length 2 vectyor, treat as asymmetric window for before
%   start and after end
%
%output:
%
%   xvec: tmin:dt:tmax. size nx
%   
%   spikes_pertrial: count of spikes. size (nt,nx)

if numel(wndw) ==2
    wndw_l = wndw(1);
    wndw_r = wndw(2);
else
    wndw_l = wndw;
    wndw_r = wndw;
end

nt = length(handles.start);
xvec = tmin:dt:tmax;
nx = numel(xvec);
spikes_binned = zeros(nt,nx);

%find trial spikes by searchign range between trial start and
%end/violation,
%+- wndw num seconds (for spikes, wndw= 1, stimuli wndw =0 are typical)

%find alignment data
switch alignment
    case 'start'
        alignHandle = handles.start;
    case 'choice'
        alignHandle = handles.choice;
    case 'pokeend'
        alignHandle = handles.leavecpoke;
    case 'end'
        alignHandle = handles.end;
    case 'lastflash'
        alignHandle = handles.lastflash;
end

for j = 1:nt
    %if rat participates in trial use handles.end
    if isfield(handles, 'end')
        these = spiketimes>=handles.start(j)-wndw_l & spiketimes<=handles.end(j)+wndw_r;
        spikes_j = spiketimes(these)-alignHandle(j);
    %if not, use the time of leaving center poke
    else
        these = find(spiketimes>=handles.start(j)-wndw_l & spiketimes<=handles.leavecpoke(j)+wndw_r);
        spikes_j = spikestimes(these)-alignHandle(j);
    end
    
    %sort into bins, aligned to a specific event
    binedges = [xvec,xvec(end)+dt];
    yind = discretize(spikes_j,binedges);
    
    for m = 1:nx
        spikes_binned(j,m) = sum(numel(spikes_j(yind==m)));
    end
    
end