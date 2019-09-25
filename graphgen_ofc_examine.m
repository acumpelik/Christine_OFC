%Script to examine trial-averaged firing rates, aligned at event onsets
%(PSTH) and raster plots for specific sessions. Also lists selectivity of
%each neuron to different experimental/behavioral conditions


a = load('concatdata_ofc_start.mat');
A = a.A;
a = load('concatdata_ofc_lastflash.mat');
B = a.A;
a = load('concatdata_ofc_choice.mat');
C = a.A;
a = load('concatdata_ofc_end.mat');
D = a.A;
%% filter and create functions for selectivity
usevec = zeros(1,numel(A));
for j = 1:numel(A)
    usevec(j) = A{j}.isUsable;
end
usevec = find(usevec==1);

%Safe risky selective; Safe = 1, risky = -1. nonselective = 0
isRightSafe= @(A,j) A{j}.right_prob==1;
isLeftSafe= @(A,j) A{j}.left_prob==1;    
bothsafe= @(A,j) isRightSafe(A,j) & isLeftSafe(A,j);
choseSafe = @(A,j) (isRightSafe(A,j) & A{j}.went_right==1) | ...
                (isLeftSafe(A,j) & A{j}.went_right==0);
mask1 = @(A,j) choseSafe(A,j) & A{j}.hits==1;
mask2 = @(A,j) ~choseSafe(A,j) & A{j}.hits==1;
n_selective_safeRisky = selectiveNeuronCalc(A,mask1,mask2);

%left right selective. right = 1, left = -1, nonselective = 0
mask1 = @(A,j) A{j}.went_right == 1;
mask2 = @(A,j) A{j}.went_right == 0; 
n_selective_right = selectiveNeuronCalc(A,mask1,mask2);

%check previous reward vs. no reward  selectivity. reward = 1, loss = -1,
%nonselective = 0
prev_hit_fcn = @(A,j)[nan; A{j}.hits(1:end-1)]; 
mask1 = @(A,j) prev_hit_fcn(A,j) ==1  & ~isnan(A{j}.hits);
mask2 = @(A,j) prev_hit_fcn(A,j) ==0  & ~isnan(A{j}.hits);
n_selective_preReward = selectiveNeuronCalc(A,mask1,mask2);

%check current reward vs. no reward  selectivity. reward = 1, loss = -1,
%nonselective = 0
mask1 = @(A,j) A{j}.hits == 1 & ~isnan(A{j}.hits);
mask2 = @(A,j) A{j}.hits == 0 & ~isnan(A{j}.hits); 
n_selective_reward = selectiveNeuronCalc(A,mask1,mask2);


%% run plotting functions for neuron number ind in list of usable neurons
ind = 100;
ofc_examine(usevec(ind),A,B,C,D,20)
actind = usevec(ind) %actual index infhames
disp('right/left, safe/risky, reward/loss, pre-reward/pre-loss')
disp([n_selective_right(usevec(ind)),n_selective_safeRisky(usevec(ind)),...
    n_selective_reward(usevec(ind)), n_selective_preReward(usevec(ind))]);