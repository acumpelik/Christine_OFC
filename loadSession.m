% This script will load trials from a session (doesn't work as a function, b/c it doesn't load vars)
% clearvars -except session avgfr_session; clc

% before running, type "session =" and whatever session you want into the command window

clearvars avgfr_trials handles hmat_choice hmat_end hmat_lastflash hmat_pokeend hmat_start n nk...
    trialTimes chosenprob hits alignHandle cross spikesBinned
[fnames, units, ~, ~, rats] = getfnames;    % get the filenames from the excel sheet
                                            % determine parameters such as rat, if multiunit             
load(strcat(['C:\Christine_data\parsed_data', filesep, fnames{session}, '.mat']))