clc; clear; close all;

% File paths for the input signals
file1 = 'Comm_Project/Short_QuranPalestine.wav';
file2 = 'Comm_Project/Short_FM9090.wav';

% Read the stereo signals using wavread
[stereo1, fs1] = audioread(file1); % Use wavread instead of audioread
[stereo2, fs2] = audioread(file2); % Ensure both files have similar structure

% Convert stereo to mono by averaging the two channels
mono1 = stereo1(:,1) + stereo1(:,2);
mono2 = stereo2(:,1) + stereo2(:,2);

% Zero-pad the shorter signal to match the length of the longer one
maxLength = max(length(mono1), length(mono2));
mono1 = [mono1; zeros(maxLength - length(mono1), 1)];
mono2 = [mono2; zeros(maxLength - length(mono2), 1)];

% Create time vectors for mono signals
t1_orig = (0:length(mono1)-1) / fs1; % Time vector for mono1
t2_orig = (0:length(mono2)-1) / fs2; % Time vector for mono2

% % --- Plot Signal 1 BEFORE Upsampling: Time-Domain and Frequency-Domain ---
% figure;
% subplot(2,1,1);
% plot(t1_orig, mono1);
% title('Time-Domain Plot of Signal 1 (Before Upsampling)');
% xlabel('Time (s)');
% ylabel('Amplitude');
% grid on;
% 
% % FFT for mono1
% N1 = length(mono1); % Length of signal
% Y1 = fft(mono1); % Compute FFT
% f1 = (-N1/2:N1/2-1) * (fs1 / N1); % Frequency axis for double-sided spectrum
% Y1_shifted = fftshift(Y1); % Shift the FFT for proper double-sided display
% 
% subplot(2,1,2);
% plot(f1, abs(Y1_shifted)); % Double-sided spectrum
% title('Spectrum of Signal 1 (Before Upsampling)');
% xlabel('Frequency (Hz)');
% ylabel('Magnitude');
% grid on;
% 
% % --- Plot Signal 2 BEFORE Upsampling: Time-Domain and Frequency-Domain ---
% figure;
% subplot(2,1,1);
% plot(t2_orig, mono2);
% title('Time-Domain Plot of Signal 2 (Before Upsampling)');
% xlabel('Time (s)');
% ylabel('Amplitude');
% grid on;
% 
% % FFT for mono2
% N2 = length(mono2); % Length of signal
% Y2 = fft(mono2); % Compute FFT
% f2 = (-N2/2:N2/2-1) * (fs2 / N2); % Frequency axis for double-sided spectrum
% Y2_shifted = fftshift(Y2); % Shift the FFT for proper double-sided display
% 
% subplot(2,1,2);
% plot(f2, abs(Y2_shifted)); % Double-sided spectrum
% title('Spectrum of Signal 2 (Before Upsampling)');
% xlabel('Frequency (Hz)');
% ylabel('Magnitude');
% grid on;

% Define the upsampling factor
r = 10; % Increase sampling rate by 10 times

% Calculate new sampling frequency
new_fs = r * fs1; % New sampling frequency (44100 * 10 = 441000 Hz)

% Resample signals
mono1_resampled = interp(mono1, r); % Upsample mono1 by factor r
mono2_resampled = interp(mono2, r); % Upsample mono2 by factor r

N_resampled = max(length(mono1_resampled), length(mono2_resampled));
% Create new time vectors for resampled signals
t_new = (0:N_resampled-1) / new_fs; % New time axis for mono
f_resampled = (-N_resampled/2:N_resampled/2-1) * (new_fs / N_resampled);

% --- Plot Signal 1 AFTER Upsampling: Time-Domain and Frequency-Domain ---
figure;
subplot(2,1,1);
plot(t_new, mono1_resampled);
title('Time-Domain Plot of Resampled Signal 1 (After Upsampling)');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

% FFT for resampled mono1
N_resampled = length(mono1_resampled);
Y1_resampled = fft(mono1_resampled);
Y1_resampled_shifted = fftshift(Y1_resampled)/N_resampled ;


subplot(2,1,2);
plot(f_resampled, abs(Y1_resampled_shifted));
title('Spectrum of Resampled Signal 1 (After Upsampling)');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
grid on;

% --- Plot Signal 2 AFTER Upsampling: Time-Domain and Frequency-Domain ---
figure;
subplot(2,1,1);
plot(t_new, mono2_resampled);
title('Time-Domain Plot of Resampled Signal 2 (After Upsampling)');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

% FFT for resampled mono2
modulated2_freq = fft(mono2_resampled);
modulated_freq_shifted = fftshift(modulated2_freq)/N_resampled;

subplot(2,1,2);
plot(f_resampled, abs(modulated_freq_shifted));
title('Spectrum of Resampled Signal 2 (After Upsampling)');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
grid on;


% AM

% Carrier frequencies for DSB-SC modulation
fc1 = 100e3; % Carrier frequency for signal 1 (100 kHz)
fc2 = 150e3; % Carrier frequency for signal 2 (100 + Δf with Δf = 50 kHz)


% Generate carriers
carrier1 = cos(2 * pi * fc1 * t_new); % Carrier for signal 1
carrier2 = cos(2 * pi * fc2 * t_new); % Carrier for signal 2

% Modulate the signals using DSB-SC
modulated1 = mono1_resampled .* carrier1'; % Signal 1 modulated at 100 kHz
modulated2 = mono2_resampled .* carrier2'; % Signal 2 modulated at 150 kHz

% Construct the FDM signal by summing the modulated signals
fdm_signal = modulated1 + modulated2;

% --- Plot modulated signals: Time-Domain and Frequency-Domain ---
figure;
subplot(2,1,1);
plot(t_new, modulated1);
title('Time-Domain Plot of modulated signal 1');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

% FFT for resampled mono2
modulated2_freq = fft(modulated1);
modulated_freq_shifted = fftshift(modulated2_freq)/N_resampled;

subplot(2,1,2);
plot(f_resampled, abs(modulated_freq_shifted));
title('Spectrum of modulated signal 1 ');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
grid on;



figure;
subplot(2,1,1);
plot(t_new, modulated2);
title('Time-Domain Plot of modulated signal 2');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

% FFT for resampled mono2
modulated2_freq = fft(modulated2);
modulated2_freq_shifted = fftshift(modulated2_freq)/N_resampled;

subplot(2,1,2);
plot(f_resampled, abs(modulated2_freq_shifted));
title('Spectrum of modulated signal 2');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
grid on;



figure;
subplot(2,1,1);
plot(t_new, fdm_signal);
title('Time-Domain Plot of modulated signal');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

% FFT for resampled mono2
modulated_freq = fft(fdm_signal);
modulated_freq_shifted = fftshift(modulated_freq)/N_resampled;

subplot(2,1,2);
plot(f_resampled, abs(modulated_freq_shifted));
title('Spectrum of modulated signal');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
grid on;