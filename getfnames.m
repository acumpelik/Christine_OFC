function [fnames, units, depth, duplicate, rat, days] = getfnames
%get the names of the processed data files for each cell in the physiology
%dataset.  cmc 10/20/16.

%read in the excel spreadsheet.
datadir = 'C:\Christine_data';
[xlnum, xceltxt, ~] = xlsread(strcat([datadir, filesep, 'prospect_fnames.xlsx']), 'OFC'); % 'OFC' refers to xls tab


rat = xceltxt(2:end,3);
nlxname = xceltxt(2:end,1);
tt = xceltxt(2:end,2);

for j = 1:length(rat)
    fnames{j} = strcat([rat{j,:}, '_', nlxname{j,:},'_', tt{j,:}, '.mat']);
end
units = xceltxt(2:end,7);

depth = xlnum(:, 2);
duplicate = xlnum(:,5);

t = cellfun(@(x)x(1:15), fnames, 'UniformOutput', 0);
t = t';
days = unique(t,'rows'); %we are going to track simultaneously recorded cells.
