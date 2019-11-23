% This code will make subplots with ACGs I'm interested in.
% Dependencies: find_avgfr.m, loadSession.m, makeAutocorrelogram.m

% first run find_avgfr.m manually

%% high firing sessions

highFiringSessions = find(avgfr_session>=40)';   % find sessions over 40 Hz. (make column vector)
highFiringSessions(:,2) = avgfr_session(highFiringSessions(:,1));
                                                % append corresponding avgfr
highFiringSessions = sortrows(highFiringSessions, 2, 'descend');
                                                % sort by descending firing rate
figure(1)
clf % clear current figure
for hfs = 1:length(highFiringSessions)
    session = highFiringSessions(hfs,1);
    loadSession
    makeAutocorrelogram
    subplot(1,3,hfs); bar(closeup_lags, closeup)
    title(['#', num2str(session),', firing rate ',num2str(highFiringSessions(hfs, 2)), ' Hz.'])
    ylabel('correlation') 
end
xlabel('time (ms)')
xlim([-50 50])

% % save as .fig and .jpg
% filename = strcat(['ACGs_high_firing_sessions']);
% savefig(filename)
% saveas(gcf, filename, 'jpeg')

%% mid peak sessions
midFiringSessions = find(avgfr_session>24 & avgfr_session<40)';
                                                    % find sessions btwn 24 and 40 Hz.
midFiringSessions(:,2) = avgfr_session(midFiringSessions(:,1));
                                                    % append corresponding avgfr
midFiringSessions = sortrows(midFiringSessions, 2, 'descend');
                                                    % sort by descending firing rate
figure(2)
clf

for mfs = 1:length(midFiringSessions)
    session = midFiringSessions(mfs,1);
    loadSession
    makeAutocorrelogram
    subplot(4,6,mfs); bar(closeup_lags, closeup)
    title(['#',num2str(session),': ',num2str(midFiringSessions(mfs, 2)), ' Hz.'])
    ylabel('correlation') 
    hold on
end
xlabel('time (ms)')
xlim([-50 50])

% % save as .fig and .jpg
% filename = strcat(['ACGs_midpeak_sessions']);
% savefig(filename)
% saveas(gcf, filename, 'jpeg')

%% median (most represented) sessions
medianFiringSessions = find(avgfr_session>0.88 & avgfr_session<2.64)'; % bin number 2 and 3
                                                    % find sessions btwn 0.88 and 2.64 Hz.
medianFiringSessions(:,2) = avgfr_session(medianFiringSessions(:,1));
                                                    % append corresponding avgfr
medianFiringSessions = sortrows(medianFiringSessions, 2, 'descend');
                                                    % sort by descending firing rate
figure(3)
clf

for mfs = 1:24  %length(medianFiringSessions)
    session = medianFiringSessions(mfs,1);
    loadSession
    makeAutocorrelogram
    subplot(4,6,mfs); bar(closeup_lags, closeup)
    title(['#',num2str(session),': ',num2str(medianFiringSessions(mfs, 2)), ' Hz.'])
    ylabel('correlation') 
end
xlabel('time (ms)')
xlim([-50 50])


%% low firing sessions
lowFiringSessions = find(avgfr_session<0.88)'; % find sessions under 0.88 and 2.64 Hz.
lowFiringSessions(:,2) = avgfr_session(lowFiringSessions(:,1));
                                                    % append corresponding avgfr
lowFiringSessions = sortrows(lowFiringSessions, 2, 'descend');
                                                    % sort by descending firing rate
figure(4)
clf

for mfs = 807:826
    session = lowFiringSessions(mfs,1);
    loadSession
    makeAutocorrelogram
    subplot(4,6,mfs-806); bar(closeup_lags, closeup)
    title(['#',num2str(session),': ',num2str(lowFiringSessions(mfs, 2)), ' Hz.'])
    ylabel('correlation') 
end
xlabel('time (ms)')
xlim([-50 50])
