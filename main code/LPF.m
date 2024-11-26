% LPF Design Parameters
order = 3;              % Filter order
ripple = 1;             % Passband ripple (dB)
f_c = 22e6;             % Cutoff frequency (Hz)

% Design the Chebyshev Type I Low-Pass Filter
[num1, den1] = cheby1(order, ripple, 2*pi*f_c, 'low', 's');

% Input Signal Parameters
Fs = 200e6;             % Sampling frequency (Hz)
Ts = 1 / Fs;            % Sampling period
NFFT = 2^12;            % Number of FFT points (signal length)
Runtime = (NFFT - 1) * Ts; % Total duration of the signal

t = 0:Ts:Runtime;       % Time vector
a_in = 1;               % Amplitude of the input sine wave
phase_in = 0;           % Phase of the input sine wave
f_in = 2e5;             % Frequency of the input sine wave (Hz)

y_in = a_in * sin(2 * pi * f_in * t + phase_in);  % Input signal (sine wave)

% Apply the Filter to the Input Signal
y_out = filter(num1, den1, y_in);  % Filter the signal

% Plot the Original and Filtered Signals
figure;
subplot(2, 1, 1);
plot(t, y_in);
title('Original Input Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(2, 1, 2);
plot(t, y_out);
title('Filtered Output Signal');
xlabel('Time (s)');
ylabel('Amplitude');

% Frequency Response of the Filter
figure;
freqz(num1, den1, NFFT, Fs);  % Frequency response visualization
title('Frequency Response of the Chebyshev Type I Low-Pass Filter');
