%range of values to search. from -1 to 1

%hmat_sess_zscore is a z-scored verion of our heatmap: 
%   size (nsess,nt) for nsess neurons, nt time points
%

peakrange_min = 21; %first time bin to look for the peak
peakrange_max = 61; %last time bin to look for the peak

peaktime = zeros(1,nsess);
for j = 1:nsess
    [peakmax,pind] = max(hmat_sess_zscore(j,peakrange_min:peakrange_max));
    peaktime(j) = A{1}.xvec(pind);
end
[B_pmax,I_pmax] = sort(peaktime);
hmat_sess_zscore_peaksorted = hmat_sess_zscore(I_pmax,:);
hmat_sess_peaksorted = hmat_sess(I_pmax,:);