function [] = makeraster(spikes,ind,usecolor)
%MAKERASTER: easy plotting script to make a raster plot
%spikes: cell of spike timings

%f = figure;
%visualize the raster plots
if nargin < 3
    usecolor = false;
end
clf

nt = numel(spikes); %number trials, neuron of interest

%for a single neuron, plot raster of the samples
marksize = floor(nt/100); %adaptive marker size to look pretty :)

for j = 1:nt
    if ~usecolor
        plot(spikes{j},j*ones(size(spikes{j})),'k.','Markersize',marksize)
    else 
        plot(spikes{j},j*ones(size(spikes{j})),'.','Markersize',marksize)
    end
    hold on;
end

set(gca,'fontsize',18);
xlabel('time, s','fontsize',18);
ylabel('trial #','fontsize',18);
title(['raster plot, neuron # ',num2str(ind)],'fontsize',18);
set(gca, 'TickDir', 'out')


