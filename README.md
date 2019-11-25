# Christine_OFC_repo

This is a repository of code made to analyze Christine Constantinople's data from her 2019 paper.

## Overview of scripts:
### Code from David/Christine
**Example_plot_for_David.m**: plots heatmap for rewarded and unrewarded trials, PSTH for rewarded and unrewarded, and waveform shape on each electrode

**concat_ofc.m**: outputs data structure A, which can be saved and used by other scripts instead of importing raw data each time

**graphgen_ofc_examine.m**: plots PSTHs aligned to certain events: trial start, port choice, last flash, and trial end; also raster plot

getfnames.m: get filenames, also units, depth, duplicate, rat, days

getmultiunit.m: get filenames of sessions with multiunit activity

makeraster.m: I don't know how this one works

nspikespertrials.m: counts the number of spikes that occurred for each trial within a session

ofc_examine.m: same as graphgen_ofc_examine.m, but you have to put input arguments, so graphgen is more streamlined

parse_choices.m: spits out chosenprob, chosenval, hits, notchosenprob,  notchosenval

shadedErrorBar.m: generates an error bar for a line plot

binspikes.m: bin spikes using discretize

example_plot_4_Andrea.m: the basis for plotPSTHbyRewardVolume.m; plots PSTH for various reward sizes in single session, and makes ordered surface plot for all sessions

hmat_sess_zscored.m: z-scored version of heatmap that is aligned to when peaks start; doesn't work on its own

selectiveNeuronCalc.m: David sent this to me to get graphgen_ofc_examine.m to work. "That chunk of the code was recreating some t-tests for neuron selectivity that Christine had done in her eLife paper tot try and characterize the cells. When you run graphgen_ofc_examine it will output some stuff to the terminal about the neuron's selectivity my using that code. not super relevant if you are just visualizing stuff, but might be interesting for you to know."

spiketimes_pertrial.m: also for graphgen_ofc_examine; takes 'spiketimes' and breaks it into spike times for each trial, aligned to some event like trial start

### My code
find_avgfr.m: plot average firing rate for all filtered sessions, then by rat, then find sessions above/below a certain threshold

makeAutocorrelogram.m: makes ACG for single session

loadSession.m: imports raw data and getfnames for a single session

plotACGs.m: make subplots with ACGs of interest

countInfs.m: unfinished. was supposed to count trials with zero duration

mutualInformationDemo.m: (archived; formerly mutualInformation.m) newer version done with David. generates a raster plot of cell firing when the clicks are on, for R = 6 uL

plotPSTHbyRewardVolume.m: plot PSTHs for various reward sizes for a single session
plotHeatmapByRewardVolume

plotHeatmapForAllSessions.m: (formerly plotHeatmapForRewarded orplotHeatmapForRewardedSessions) plots heatmap of average z-scored firing rate for all sessions

loadUsableDataset: (formerly importDataset) loads David's concatenated dataset and filters out usable sessions based on various criteria

plotISIs.m: plot distribution of interspike intervals below a certain threshold

sortHighFiring.m: sorts high firing sessions

plotHeatmapByRewVol.m: incomplete, finished versions below

plotHeatmapRew6.m: incomplete, the one that works is named v2

mutualInformationAllSessions.m: Bernoulli

mutualInformationPoisson.m: we tried to implement mutual info with a Poisson distribution, but incomplete

mutualInformationBernoulli.m: Bernoulli, but I don't know what distinguishes it from mutualInformationAllSessions

plotHeatmapRew6_v2.m: this version actually works. plots 6uL trials averaged over each session, arranged by peak onset

plotHeatmapRew12.m: plots 12uL trials averaged over each session, arranged by peak onset

plotHeatmapRew24.m: plots 24uL trials averaged over each session, arranged by peak onset

plotHeatmapRew48.m: plots 48uL trials averaged over each session, arranged by peak onset
