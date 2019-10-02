% This script will load trials from a certain session
% clearvars -except session; clc
[fnames, units, ~, ~, rats] = getfnames;    % get the filenames from the excel sheet
                                            % determine parameters such as rat, if multiunit             
load(strcat(['C:\Christine_data\parsed_data', filesep, fnames{session}, '.mat']))