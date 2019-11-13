% plot ISIs
% dependencies: find_avgfr
% find_avgrfr
%% Plot all ISIs
ISIs = diff(spiketimes);
histogram(ISIs)
title('Distribution of ISIs')
xlabel('ISI (s)')
ylabel('Number of neurons/sessions')

%% Plot subset of ISIs below threshold
smISIs = ISIs(ISIs < 0.02); % 20ms
histogram(smISIs, 200)
title('Distribution of ISIs below 20ms, bin size=200')
xlabel('ISI (ms)')
ylabel('Number of neurons/sessions')

length(smISIs)