% Clear workspace and load the filter
clear all;
close all;
clc;

% Add the Functions and Filters folder to the MATLAB path temporarily
addpath('Functions');
addpath('Filters');

% Load the filter
load RF_Band_Pass_Filter; % Ensure the filter variable is named properly in the .mat file
disp('RF Band Pass Filter successfully loaded.');

% Filter parameters
FilterOrder = 40;      % Filter order
Fs = 680e3;            % Sampling frequency (Hz)
Fc = 100e3;            % Carrier frequency (Hz)
DeltaF = 10e3;         % Bandwidth (Hz)

% Normalized frequency edges (relative to Nyquist frequency Fs/2)
F3dB1 = (Fc - DeltaF) / (Fs/2);  % Lower 3-dB cutoff frequency
F3dB2 = (Fc + DeltaF) / (Fs/2);  % Upper 3-dB cutoff frequency

% Create the filter specification object and design the filter
RF_BPF_Spec = fdesign.bandpass('N,F3dB1,F3dB2', FilterOrder, F3dB1, F3dB2);
RF_BPF = design(RF_BPF_Spec, 'butter');  % Design the filter

% Save the filter for future use
save("Filters\RF_Band_Pass_Filter.mat", 'RF_BPF_Spec', 'RF_BPF');


% Generate a sample signal (e.g., a sine wave with noise)
Fs = 48e3;             % Sampling frequency (Hz)
t = 0:1/Fs:0.01;       % Time vector
f1 = 5e3;              % Frequency of desired signal (Hz)
f2 = 20e3;             % Interference frequency (Hz)
signal = sin(2*pi*f1*t) + 0.5*sin(2*pi*f2*t); % Signal with interference

% Filter the signal
if exist('RF_BPF', 'var') % Check if filter variable exists
    filteredSignal = filter(RF_BPF, signal);
    % Or use filtfilt for zero-phase filtering: filteredSignal = filtfilt(BandPassFilt, signal);
    disp('Signal filtered successfully.');
else
    error('BandPassFilt not found in the loaded file.');
end

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

% Normalized frequency edges for the new filter
F3dB1_new = (Fc_new - DeltaF_new) / (Fs/2);  % Lower 3-dB cutoff frequency
F3dB2_new = (Fc_new + DeltaF_new) / (Fs/2);  % Upper 3-dB cutoff frequency

% Create a new filter specification object for the updated frequency
RF_BPF_Spec_New = fdesign.bandpass('N,F3dB1,F3dB2', FilterOrder, F3dB1_new, F3dB2_new);
RF_BPF_New = design(RF_BPF_Spec_New, 'butter');  % Design the updated filter

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
