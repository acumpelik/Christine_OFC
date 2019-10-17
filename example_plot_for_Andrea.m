% sample script to look at PSTH by reward volume
%%%%%% 1. plotting a PSTH for a single session %%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd('C:\Christine_data')                         % access data folder
[fnames, units, ~, ~] = getfnames;              % load filenames and info about multiunits
f_ind = 1168;                                    % choose a session

load(strcat([fnames{f_ind},'.mat']))            % load session
[~, chosenval, hits, ~] = parse_choices(S);     % chosenval = reward amount rat received
                                                % hits = 1 if the rat got water on that trial, 0 if
                                                % he did not, and nan if he terminated by leaving poke
%% 
% basic way to plot a PSTH
% plot(xvec_start,nanmean(hmat_start,1))          % plot the mean of the raster plots aligned to the
%                                                 % trial start aligned to a time period from -2 to 4

% filter by rewards and certain rew. volume
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
title(strcat('PSTH, single neuron session',{' '}, num2str(f_ind), ', by reward volume'))
legend('averaged','6 ul','12','24','48')

% date = char(datetime('now', 'Format', 'MMddyyyy_HHmmss'));
%                                             create a timestamp so Matlab doesn't overwrite figures
% filename = strcat(['PSTH_byRewardVol_', num2str(session), '_', date]);
%                                             concatenate file name
% savefig(filename)                           % save as .fig
% saveas(gcf, filename, 'jpeg')               % save as .jpg

%% plot heatmap of all session rewards

% load a concatenated data set that David made, and you have the code for
a = load('concatdata_ofc_pokeend.mat');
A = a.A;

%%

% count all sessions, and define a mask for counting sessions filtered according to my parameters
numSessions_old = numel(A);                 % number of all sessions
usableVec = zeros(numel(A),1);              % logical of usable sessions (fire more than 2x/trial)

% filter sessions for usability and other the things I want
for j = 1:numSessions_old                   
    % can add more filtering here. you already code for it to remove MUA
    if A{j}.isUsable
        usableVec(j) = 1;
    end
end
usableSessions = sum(usableVec);            % count number of usable sessions

% define a heatmap mask with filtered sessions
hmat_usable = zeros(usableSessions,numel(A{1}.xvec));

% loop over each session, and PSTH add to hmat;
usableInds = find(usableVec);               % indices of usable sessions
avgSpikesPerSession = zeros(usableSessions,1); % define mask for avg # of spikes per session
for j = 1:usableSessions
    if  A{usableInds(j)}.isUsable           % if session is usable, grab correct index
     hmat_usable(j,:) = nanmean( A{usableInds(j)}.hmat,1 );
    end
    
    % average number (over trials) of spikes for each session
    % can change to firing rate if you want. would need to make sure time
    % corresponds to when those spikes counts were taken
    avgSpikesPerSession(j) = nanmean(A{usableInds(j)}.nspikes);
end


%% order the data
[sessionsByAvgFR,indicesAvgFR] = sort(avgSpikesPerSession);
hmat_sess_sorted = hmat_usable(indicesAvgFR,:);

% surf(A{1}.xvec,1:usableSessions,hmat_sess_sorted)
imagesc(A{1}.xvec,1:usableSessions,hmat_sess_sorted)
colormap default
xlabel('time (s)')
ylabel('session')
set(gca,'fontsize',15)
set(gca, 'TickDir', 'out'); box off; colorbar

%% subset of high-firing data
% count only sessions that have B greater than 100
% variables are: sessionsByAvgFR, hmat_sess_sorted, indicesAvgFR
% 
% hmat_high_firing = zeros(sum(sessionsByAvgFR>100), numel(A{1}.xvec));
% 
% hmat_high_firing = hmat_sess_sorted(:, indicesAvgFR(sessionsByAvgFR>100));
% % imagesc(A{1}.xvec,1:usableSessions,hmat_sess_sorted)
% imagesc(A{1}.xvec,1:sum(sessionsByAvgFR>100),hmat_high_firing)
% % 
% % for 1:length(B)
% %     if sessionsByAvgFR>100:
% %         hma
% %     end
% % end

%% z-scored

    


