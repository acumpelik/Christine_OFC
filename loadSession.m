% This script will load trials from a certain session
% clearvars -except session avgfr_session; clc
function loadSession(session)
clearvars avgfr_trials handles hmat_choice hmat_end hmat_lastflash hmat_pokeend hmat_start n nk trialTimes...
    chosenprob hits alignHandle cross spikesBinned
[fnames, units, ~, ~, rats] = getfnames;    % get the filenames from the excel sheet
                                            % determine parameters such as rat, if multiunit             
load(strcat(['C:\Christine_data\parsed_data', filesep, fnames{session}, '.mat']))
end