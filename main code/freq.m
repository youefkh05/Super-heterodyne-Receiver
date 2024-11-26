% Clear workspace
clear all;
close all;
clc;

% Signal Parameters
Fs = 400e3;              % Sampling frequency (Hz)
t = 0:1/Fs:0.01;        % Time vector
f1 = 100e3;              % Frequency of desired signal (Hz)
f2 = 130e3;             % Interference frequency (Hz)
signal = sin(2*pi*f1*t) + 0.5*sin(2*pi*f2*t); % Signal with interference

% FFT Parameters
NFFT = 2^nextpow2(length(signal)); % FFT length
frequencies = Fs * (0:(NFFT/2)) / NFFT; % Frequency vector for positive spectrum

% Design Bandpass Filter in Frequency Domain
Fc = 100e3;             % Carrier frequency (Hz)
DeltaF = 10e3;          % Bandwidth (Hz)
F3dB1 = Fc - DeltaF;    % Lower cutoff frequency
F3dB2 = Fc + DeltaF;    % Upper cutoff frequency

% Create a frequency mask for bandpass filter
H = zeros(1, NFFT);      % Initialize frequency response
H(frequencies >= F3dB1 & frequencies <= F3dB2) = 1; % Passband in positive spectrum
H(frequencies >= (Fs - F3dB2) & frequencies <= (Fs - F3dB1)) = 1; % Passband in negative spectrum

% Apply the Filter in the Frequency Domain
signalFFT = fft(signal, NFFT); % FFT of the signal
filteredFFT = signalFFT .* H;  % Apply the filter

% Transform Back to Time Domain
filteredSignal = ifft(filteredFFT, NFFT, 'symmetric'); % IFFT to get filtered signal

% Plot the Original and Filtered Signals
figure;
subplot(2, 1, 1);
plot(t, signal);
title('Original Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(2, 1, 2);
plot(t, filteredSignal(1:length(signal))); % Match lengths
title('Filtered Signal (Frequency Domain)');
xlabel('Time (s)');
ylabel('Amplitude');

% Visualize Frequency Responses
figure;
subplot(2, 1, 1);
plot(frequencies, abs(signalFFT(1:NFFT/2+1))); % Original Signal Spectrum
title('Original Signal Spectrum');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

subplot(2, 1, 2);
plot(frequencies, abs(filteredFFT(1:NFFT/2+1))); % Filtered Signal Spectrum
title('Filtered Signal Spectrum');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
