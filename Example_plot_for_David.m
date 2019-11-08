%function Example_plot_for_David
%This will plot the firing rate of a totally arbitrary cell depending on
%whether the previous trial was rewarded or not, just to give David a sense 
%how I have worked with this dataset. cmc 6/28/19

[fnames, units, ~, ~] = getfnames; % get the filenames from the excel sheet, and determine whether multiunit
for m = 710 % 1:length(fnames); % only select neuron # 76
     load(strcat(['parsed_data', filesep, fnames{m}, '.mat'])); %hmats were generated using save_heatmats.m
                    % cds to the parsed_data folder and opens the .mat file
                    % filesep just generates forward or backslashes
                           % depending on the OS
     
     %%ONLY LOOK AT CELLS THAT HAD >=2 SPIKES ON HALF OF TRIALS.
     n = nspikespertrials(spiketimes, handles, 1); 
     nk = n>=2; % number of spikes per trials for cells that spike >=2
     if nanmean(nk)>=.5 % discard cells that are silent on more than half the trials
         
         [~, ~, hits, ~] = parse_choices(S);   % a function that returns hits (see below)
         %hits = 1 if the rat got water on that trial, 0 if the rat didn't
         %get water, and nan if the rat violated the trial by terminated
         %center fixation.
         prev_hit = [nan; hits(1:end-1)]; % previous  trial was rewarded/unrewarded; shifts hits vector forward by one
         
         hmat = hmat_start; %matrix of firing rates on each trial aligned to trial start; CAN CHANGE TO A DIFFERENT HMAT
         xvec = xvec_start; %x vector of time points
         
         figure; subplot(2,2,1);
         imagesc(hmat(prev_hit==1 & ~isnan(hits),:)); % imagesc = image with scaled colors
         title(strcat(['Cell #', num2str(m), '. Post-rewarded trials']));
         set(gca, 'TickDir', 'out'); box off; colorbar % gca: current axes for chart; set tick direction to be outside
         
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
     
     if nanmean(nk)>=.5
         time = handles.end(end) - handles.start(1);
         
         
         
         
         
     end
     
     
     
     
     
end