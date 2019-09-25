function [] = ofc_examine(ind,A,B,C,D,offset)
%OFC_EXAMINE function to plot summary information for ofc sessions
%
%inputs: 
%session number. should reflect same ordering in getfnames
%order of concatenated data structures made from concatdata_ofc(): 
%A = start trials, 
%B = lastflash, 
%C = choice, 
%D = end
%offset: integer that can be used to renumber the figures to plot multiple
%         sessions at the same time without figures overwriting each other
%
%outputs: plots PSTH of neurons (error bars are SEM), and raster plot
%
%file dependencies: shadedErrorBar, makeraster

if ~exist('offset','var')
    offset = 0;
end
figure(1+offset)
clf;
subplot(2,2,1)
shadedErrorBar(A{ind}.xvec,nanmean(A{ind}.hmat),sqrt(nanvar(A{ind}.hmat)/numel(~isnan(A{ind}.hits))))
xlabel('time from enter center poke (s)')
ylabel('rate (Hz)')
title('start trial center poke')

subplot(2,2,2)
shadedErrorBar(B{ind}.xvec,nanmean(B{ind}.hmat),sqrt(nanvar(B{ind}.hmat)/numel(~isnan(B{ind}.hits))))
xlabel('time from last flash (s)')
ylabel('rate (Hz)')
title('last-flash aligned')

subplot(2,2,3)
shadedErrorBar(C{ind}.xvec,nanmean(C{ind}.hmat),sqrt(nanvar(C{ind}.hmat)/numel(~isnan(C{ind}.hits))))
xlabel('time from choice (s)')
ylabel('rate (Hz)')
title('port choice aligned')

subplot(2,2,4)
shadedErrorBar(D{ind}.xvec,nanmean(D{ind}.hmat),sqrt(nanvar(D{ind}.hmat)/numel(~isnan(D{ind}.hits))))
xlabel('time from end(s)')
ylabel('rate (Hz)')
title('end trial aligned')

%calc raster plots
%load origininal data
datadir =  '/Users/dhocker/projects/ofc/data/PhysiologyData/Christine_OFC_2019/parsed_data/';
a = load(strcat([datadir,A{ind}.fname]));

figure(2+offset)
clf
spikes_pertrial = spiketimes_pertrial(a.spiketimes, a.handles, 1);

makeraster(spikes_pertrial,ind,false)

assert(strcmp(A{ind}.fname,B{ind}.fname),'A and B dont match')
assert(strcmp(A{ind}.fname,C{ind}.fname),'A and C dont match')
assert(strcmp(A{ind}.fname,D{ind}.fname),'A and D dont match')

disp(strcat([A{ind}.fname,'.mat']))
%disp(split(A{1}.fname,'_')')
