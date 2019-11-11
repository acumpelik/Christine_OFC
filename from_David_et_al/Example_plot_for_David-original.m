function Example_plot_for_David
%This will plot the firing rate of a totally arbitrary cell depending on
%whether the previous trial was rewarded or not, just to give David a sense 
%how I have worked with this dataset. cmc 6/28/19

[fnames, ~, ~, ~] = getfnames;

for m = 76; % 1:length(fnames);
     load(strcat(['parsed_data', filesep, fnames{m}, '.mat'])); %hmats were generated using save_heatmats.m
     
     %%ONLY LOOK AT CELLS THAT HAD >=2 SPIKES ON HALF OF TRIALS.
     n = nspikespertrials(spiketimes, handles, 1);
     nk = n>=2;
     if nanmean(nk)>=.5;
         
         [~, ~, hits, ~] = parse_choices(S);   
         %hits = 1 if the rat got water on that trial, 0 if the rat didn't
         %get water, and nan if the rat violated the trial by terminated
         %center fixation.
         prev_hit = [nan; hits(1:end-1)];
         
         hmat = hmat_start; %matrix of firing rates on each trial aligned to trial start
         xvec = xvec_start; %x vector of time points
         
         figure; subplot(2,2,1);
         imagesc(hmat(prev_hit==1 & ~isnan(hits),:));
         title(strcat(['Cell #', num2str(m), '. Post-rewarded trials']));
         set(gca, 'TickDir', 'out'); box off; colorbar
         
         subplot(2,2,2);
         imagesc(hmat(prev_hit==0 & ~isnan(hits),:));
         title('Post-unrewarded trials');
         set(gca, 'TickDir', 'out'); box off; colorbar
         
         subplot(2,2,3);
         plot(xvec, nanmean(hmat(prev_hit==1 & ~isnan(hits),:)), 'b'); hold on
         plot(xvec, nanmean(hmat(prev_hit==0 & ~isnan(hits),:)), 'k');
         set(gca, 'TickDir', 'out'); box off;
         xlabel('Time from cpoke (s)');
         
         subplot(2,2,4);
         plot(waveform);
         set(gca, 'TickDir', 'out'); box off;
         title('Waveform on each wire of tetrode');
         
         
     end
end