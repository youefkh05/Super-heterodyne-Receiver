% Clear workspace and load the filter
clear all;
close all;
clc;

% Add the Functions and Filters folder to the MATLAB path temporarily
addpath('Functions');
addpath('Filters');

% Filter parameters
FilterOrder = 40;      % Filter order
Fs = 680e3;            % Sampling frequency (Hz)
Fc = 100e3;            % Carrier frequency (Hz)
DeltaF = 10e3;         % Bandwidth (Hz)

RF_BPF = createBandPassFilter(Fc, Fs, DeltaF);


% Generate a sample signal (e.g., a sine wave with noise)
Fs = 48e3;             % Sampling frequency (Hz)
t = 0:1/Fs:0.01;       % Time vector
f1 = 90e3;              % Frequency of desired signal (Hz)
f2 = 120e3;             % Interference frequency (Hz)
signal = sin(2*pi*f1*t) + 0.5*sin(2*pi*f2*t); % Signal with interference

% Filter the signal
filteredSignal = filter(RF_BPF, signal);

% Plot the original and filtered signals
figure;
subplot(2,1,1);
plot(t, signal);
title('Original Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(2,1,2);
plot(t, filteredSignal);
title('Filtered Signal');
xlabel('Time (s)');
ylabel('Amplitude');

% Visualize the new filter
fvtool(RF_BPF)  % Frequency response for new carrier frequency

% Define new carrier frequency and bandwidth
Fc_new = 120e3;         % New carrier frequency (Hz)
Fs = 680e3;             % Sampling frequency (Hz)
DeltaF_new = 10e3;      % Bandwidth (Hz)

RF_BPF_New = createBandPassFilter(Fc_new, Fs, DeltaF_new);  % Design the updated filter

% Visualize the new filter's frequency response
fvtool(RF_BPF_New);
disp('Filter redesigned successfully for new carrier frequency.');

filteredSignal = filter(RF_BPF_New, signal);
% Or use filtfilt for zero-phase filtering: filteredSignal = filtfilt(BandPassFilt, signal);
disp('Signal filtered successfully.');

% Plot the original and filtered signals
figure;
subplot(2,1,1);
plot(t, signal);
title('Original Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(2,1,2);
plot(t, filteredSignal);
title('Filtered Signal');
xlabel('Time (s)');
ylabel('Amplitude');


% Remove added paths
rmpath('Functions');
rmpath('Filters');
