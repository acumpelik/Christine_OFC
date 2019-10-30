%script to compress the start, choice, and poke data into 3 separate files
%just so that you aren't opening up tons of files

cd('C:\GitHub\Christine_OFC_code\from_David_et_al\')
[fnames, ~, ~, ~] = getfnames;


%TODO: add handle for if sample is useful for analysis

%current structure
%A: cell array indexed by file order from fnames
%A{i} is a struc object with following fields
%   hmat: the binned firing rates
%   xvec: the timing of the bins in hmat
%   hits: if each trial was a success or not (1=yes,0=no,nan=violated
%   trial)
%   went_right: was the right-side port chosen?
%   left_vol/right_vol: left port/right port volume of water on each trial
%   left_prob/right_prob: left and right port probabilities
%   nspikes: total number of spikes per trial
%   fname: files name data taken from
%   isUsable: boolean for whether or not to include in analysis
%   waittime: time between leaving center poke and making choice
%   ratname: which animal was used.

%going to make 3-4 version of this structure for the main time-aligned rates


type = 'start'; %concat_ofc_start
%type = 'pokeend'; %concat_ofc_pokeend
%type = 'choice'; %concat_ofc_choice
%type = 'lastflash'; %concat_lastflash
%type = 'end'; %concat_lastflash


%create a data structure
A = {};

for j = 1:numel(fnames) % numel returns the number of elements in a matrix
    if mod(j,100) == 0 % mod returns the remainder after division
        disp(j)
    end
    
   load(strcat(['parsed_data', filesep, fnames{j}, '.mat'])); %hmats were generated using save_heatmats.m
   
   [chosenprob, ~, hits, ~] = parse_choices(S);
   
   switch type
       case 'start'
           A{j}.hmat = hmat_start;
           A{j}.xvec = xvec_start;
       case 'pokeend'
           A{j}.hmat = hmat_pokeend;
           A{j}.xvec = xvec_pokeend;
       case 'choice'
           A{j}.hmat = hmat_choice;
           A{j}.xvec = xvec_choice;
       case 'lastflash'
           A{j}.hmat = hmat_lastflash;
           A{j}.xvec = xvec_choice;
       case 'end'
           A{j}.hmat = hmat_end;
           A{j}.xvec = xvec_end;
       otherwise
           disp('incorrect type supplied')
           break
   end
   
   A{j}.hits = hits;
   A{j}.went_right = handles.went_right; %different than parse_choice
   A{j}.this_left_volume = S.pd{:}.this_left_volume;
   A{j}.this_right_volume = S.pd{:}.this_right_volume;
   A{j}.left_prob = S.pd{:}.left_prob;
   A{j}.right_prob = S.pd{:}.right_prob;
   A{j}.fname = fnames{j};
   
   
   %classify cells as useable in analysis,
   %having  >=2 spikes on half of trials
    n = nspikespertrials(spiketimes, handles, 1);
    A{j}.nspikes = n;
    nk = n>=2;
    if nanmean(nk) > 0.5 
        A{j}.isUsable = true;
    else
        A{j}.isUsable = false;
    end

   %TODO: ADD bit about checking for missing data (like sessions
   %j=1029,1506)
   A{j}.waittime = handles.choice-handles.leavecpoke;
   A{j}.ratname = S.ratname;
   
   
end

%% save
fname = strcat(['concatdata_ofc_',type,'.mat']);

save(fname,'A')

