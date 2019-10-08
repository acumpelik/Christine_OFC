%% load session and find trials where each reward volume was presented
session = 741;
loadSession

leftVol = S.pd{1, 1}.this_left_volume;
unique(leftVol)

trialsVol6 =  find(leftVol==6);
trialsVol12 = find(leftVol==12);
trialsVol24 = find(leftVol==24);
trialsVol48 = find(leftVol==48);

%% find spike probability given reward volume P(X|Y)
% bin spikes in a way that each bin has only 0 or 1 spikes

dt = 0.001;                                         % bin size in s

startTime = handles.lbups{1}(1);
endTime = handles.lbups{1}(end);






