% sample script to look at PSTH by reward volume for a single session
% formerly example_plot_for_Andrea.m
cd('C:\Christine_data')                         % access data folder
[fnames, units, ~, ~] = getfnames;              % load filenames and info about multiunits

%% plotting PSTH for a single session
session = 157;                                  % choose a session
load(strcat([fnames{session},'.mat']))          % load session
[~, chosenval, hits, ~] = parse_choices(S);     % import the following from parse_choices:
                                                % chosenval = reward amount rat received
                                                % hits = 1 if the rat got water on that trial, 0 if
                                                    % he did not, and nan if he terminated by
                                                    % leaving poke
                                                    
% % basic way to plot a PSTH
% plot(xvec_start,nanmean(hmat_start,1))          % plot the mean of the raster plots aligned to the
%                                                 % trial start aligned to a time period from -2 to 4
                                                    
%% plot PSTHs filtered by reward volume

% filter by rewards and certain reward volumes
RN_mask = ~isnan(chosenval);                        % a logical that finds only rewarded trials
R6_mask = chosenval==6;                             % a logical that finds trials where rat got 6 uL
R12_mask = chosenval==12;
R24_mask = chosenval==24;
R48_mask = chosenval==48;

figure(1)
clf
plot(xvec_start,nanmean(hmat_start(RN_mask,:),1),'k','linewidth',2)
hold on
plot(xvec_start,nanmean(hmat_start(R6_mask,:),1),'linewidth',2)
plot(xvec_start,nanmean(hmat_start(R12_mask,:),1),'linewidth',2)
plot(xvec_start,nanmean(hmat_start(R24_mask,:),1),'linewidth',2)
plot(xvec_start,nanmean(hmat_start(R48_mask,:),1),'linewidth',2)

% plot designations
set(gca,'fontsize',15)
xlabel('time (s)')
ylabel('rate (Hz)')
title(strcat('PSTH, single neuron session',{' '}, num2str(session), ', by reward volume'))
legend('averaged','6 ul','12','24','48')

% % save plot if desired, add a timestamp
% date = char(datetime('now', 'Format', 'MMddyyyy_HHmmss'));
%                                             create a timestamp so Matlab doesn't overwrite figures
% filename = strcat(['PSTH_byRewardVol_', num2str(session), '_', date]);
%                                             concatenate file name
% savefig(filename)                           % save as .fig
% saveas(gcf, filename, 'jpeg')               % save as .jpg