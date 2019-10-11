% sample script to look at PSTH by reward volume
%%%%%% 1. plotting a PSTH for a single session %%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd('C:\Christine_data')                         % access data folder
[fnames, units, ~, ~] = getfnames;              % load filenames and info about multiunits
f_ind = 1867;                                    % choose a session

load(strcat([fnames{f_ind},'.mat']))            % load session
[~, chosenval, hits, ~] = parse_choices(S);     % chosenval = reward amount rat received
                                                % hits = 1 if the rat got water on that trial, 0 if
                                                % he did not, and nan if he terminated by leaving poke
%% 
% basic way to plot a PSTH
% plot(xvec_start,nanmean(hmat_start,1))          % plot the mean of the raster plots aligned to the
%                                                 % trial start aligned to a time period from -2 to 4

% filter by rewards and certain rew. volume
R6_mask = chosenval==6;                         % a logical that finds trials where rat got 6 uL
R12_mask = chosenval==12;
R24_mask = chosenval==24;
R48_mask = chosenval==48;

figure(1)
clf
plot(xvec_start,nanmean(hmat_start,1),'k','linewidth',2)
hold on
plot(xvec_start,nanmean(hmat_start(R6_mask,:),1),'linewidth',2)

plot(xvec_start,nanmean(hmat_start(R12_mask,:),1),'linewidth',2)

plot(xvec_start,nanmean(hmat_start(R24_mask,:),1),'linewidth',2)

plot(xvec_start,nanmean(hmat_start(R48_mask,:),1),'linewidth',2)

set(gca,'fontsize',15)
xlabel('time (s)')
ylabel('rate (Hz)')
title(strcat('PSTH, single neuron session',{' '}, num2str(f_ind), ', by reward volume'))
legend('averaged','6 ul','12','24','48')

date = char(datetime('now', 'Format', 'MMddyyyy_HHmmss'));
                                            % create a timestamp so Matlab doesn't overwrite figures
filename = strcat(['PSTH_byRewardVol_', num2str(session), '_', date]);
                                            % concatenate file name
savefig(filename)                           % save as .fig

% saveas(gcf, filename, 'jpeg')               % save as .jpg

%% look at all session rewards

% load a concatenated data set that David made, and you have the code for
a = load('concatdata_ofc_pokeend.mat');
A = a.A;

%%
ns_old = numel(A);
usableVec = zeros(numel(A),1); % mask of sessions that are usable
for j = 1:ns_old
    % if you want to do more filtering, add it here. you arleady code for it
    % to remove multi unit
    if A{j}.isUsable
        usableVec(j) = 1;
    end
end
nsess = sum(usableVec); %number of usable session

hmat_sess = zeros(nsess,numel(A{1}.xvec));

% loop over each session, and add to hmat_sess;
use_inds = find(usableVec);
nspikes_persession = zeros(nsess,1);
for j = 1:nsess
    if  A{use_inds(j)}.isUsable %if session is usuable, grab correct index
     hmat_sess(j,:) = nanmean( A{use_inds(j)}.hmat,1 );
    end
    
    % average number (over trials) of spikes for each session
    % can chnage to firing rate if you want. would need to makes ure time
    % corresponds to when those spikes counts were taken
    nspikes_persession(j) = nanmean(A{use_inds(j)}.nspikes);
end


%% order the data
[B,I] = sort(nspikes_persession);
hmat_sess_sorted = hmat_sess(I,:);


surf(A{1}.xvec,1:nsess,hmat_sess_sorted)
xlabel('time (s)')
ylabel('session')
set(gca,'fontsize',15)
