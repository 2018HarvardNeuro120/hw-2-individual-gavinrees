clear all

load exposure_stimulus_experiment.mat

stimulus_start_times = 0:1/6:(60-1/6); % In seconds
%%Part a
%make a set of coordinates so as to use scatter to plot x,y positions that
%correspond to rasters.
coordinates = ones(size(spikes_single_unit, 1),2);

%find y coordinate for each spike time and find its time relative to the
%stimulus presentation
for ind = 1:size(spikes_single_unit,1)
    spikeTime = spikes_single_unit(ind);
    rasterLevel = floor(6 * spikeTime);
    shiftedSpikeTime = spikeTime - 1/6 * rasterLevel;
    coordinates(ind,1) = shiftedSpikeTime;
    coordinates(ind,2) = rasterLevel;
end
scatter(coordinates(:,1), coordinates(:,2),'filled' );
title("Raster plot of single neuron response to stimulus");
xlabel("Time during 1/6 second stimulus");
ylabel("Trial number");
%% Part b&c

relativeSpikeTimes = coordinates(:,1);

%Create skeleton of smoothedFiringRate vector. First column is set to zero,
%and will be filled with the sum of gaussians centered at the relative
%spike times evaluated at the corresponding value in the second column
smoothedFiringRate = [linspace(0,0,1000); linspace(0,1/6, 1000)]';

for spikeTime = relativeSpikeTimes'
    densities = normpdf(smoothedFiringRate(:,2), spikeTime, 0.005);
    smoothedFiringRate(:,1) = smoothedFiringRate(:,1) + densities;
end
smoothedFiringRate(:,1) = smoothedFiringRate(:,1)/360;
plot(smoothedFiringRate(:,2),smoothedFiringRate(:,1))
%% Problem 1, part d

%doesn't depend on previous sections and they tend to clutter the workspace
%and lead to strange bugs. Best to kick them out
clear all

load exposure_stimulus_experiment.mat

%change from time since beginning of audio to time since beginning of
%individual stimulus.
compressToStimulus = @(arr) (6 * arr - floor(6*arr))/6;

compressedControl = compressToStimulus(spikes_control);
compressedExp = compressToStimulus(spikes_exp);

% histogram(compressedControl);
% hold on 
% histogram(compressedExp);

binWidth = 0.005;
[controlHist,expHist, bins] = deal(0:binWidth:(1/6));
getSpikesInBin = @(bin,d) sum((bin <= d) & ((bin + binWidth) >= d));

numTrialsControl = floor(6* spikes_control(end));
numTrialsExp = floor(6 * spikes_exp(end));

for bin= bins
    index = 1 + floor(bin/0.005);
    controlHist(index) = getSpikesInBin(bin,compressedControl)/(binWidth*numTrialsControl);
    expHist(index) = getSpikesInBin(bin,compressedExp)/(binWidth*numTrialsExp);
end
    
plot(bins, controlHist);
hold on
plot(bins, expHist);


legend("control","experimental");
title("Total response to stimulus in control vs. exposed rat")
ylabel("Firing Rate (Spikes/s)");
xlabel("Time since stimulus (s)")




    








