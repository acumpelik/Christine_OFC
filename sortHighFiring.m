%% subset of high-firing data
% count only sessions that have B greater than 100
% variables are: sessionsByAvgFR, hmat_sess_sorted, indicesAvgFR

hmat_high_firing = zeros(sum(sessionsByNumSpikes>100), numel(A{1}.xvec));
num_high_firing_sessions = sum(sessionsByNumSpikes>100);

hmat_high_firing = hmat_sess_sorted(indicesAvgNumSpikes(sessionsByNumSpikes>100), :);
% imagesc(A{1}.xvec,1:numUsableSessions,hmat_sess_sorted)
imagesc(A{1}.xvec, 1:100, hmat_sess_sorted(end-100:end, :))
% imagesc(A{1}.xvec,1:sum(sessionsByNumSpikes>100),hmat_high_firing)
% 
% for 1:length(B)
%     if sessionsByAvgFR>100:
%         hma
%     end
% end