function [fnames, units, depth, duplicate, multi, days] = getmultiunit
%get the names of the processed data files for each cell in the physiology
%dataset.  cmc 10/20/16.

%read in the excel spreadsheet.
curdir = pwd;
[xlnum, xceltxt, ~] = xlsread(strcat([curdir, filesep, 'prospect_fnames.xlsx']), 'OFC'); % 'OFC' refers to xls tab


multi = xceltxt(2:end,7);

for j = 1:length(multi)

end
units = xceltxt(2:end,7);

depth = xlnum(:, 2);
duplicate = xlnum(:,5);

t = cellfun(@(x)x(1:15), fnames, 'UniformOutput', 0);
t = t';
days = unique(t,'rows'); %we are going to track simultaneously recorded cells.
