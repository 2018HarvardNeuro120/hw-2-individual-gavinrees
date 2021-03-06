clear all

% Load DMR stimulus specrogram and spiking responses from one neuron
load dmr_experiment

% Plot spectrogram of stimulus
plot_spectrogram(stim_spectrogram, stim_time, stim_freq)

%% Generate STA
t_past = 125; % in ms
t_future = 125; % in ms
sampling_rate = mean(median(diff(stim_time)));
sta_time = (-t_past/1000):sampling_rate:(t_future/1000);
sta_freq = stim_freq;

% sta = ???
%initialize blank array
sta = zeros(38,size(sta_time,2));
for sp = spikes'
    %get time window to look in
    timeWindow = sta_time + sp;
    beginning = timeWindow(1);
    timeEnd = timeWindow(end);
    %get indices of times in the window
    indices = find(stim_time >=beginning & stim_time <= timeEnd);
    %if the spike time doesn't fall exactly on a stimulus time, we pretend
    %like it fell on the one directly after it (to avoid confusion with 
%   correlated sta afterwards) and add a following spectrogram value accordingly. 
    if size(indices,2) ~= 51
          indices = [indices (indices(end) + 1)];
    end
    %finally get spectrogram in the time window
    neighborhood = stim_spectrogram(:,indices);
    sta = sta + neighborhood;
end
%average
numSpikes = size(spikes,1);
sta = sta / numSpikes;

% Plot results
figure(2)
plot_spectrogram(sta, sta_time, sta_freq);
xlabel('Time relative to spike (ms)')
colorbar