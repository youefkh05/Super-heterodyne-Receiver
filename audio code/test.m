clear;
clc;
[file,path]=uigetfile('*.*');
mp=strcat(path,file);
% Step 1: Read the MP3 file
[audioData, sampleRate] = audioread(mp);

% Convert to mono if stereo
if size(audioData, 2) == 2
    audioData = mean(audioData, 2);
end

% Step 2: Compute the FFT
N = length(audioData);
frequencies = (0:N-1)*(sampleRate/N);
audioFFT = fft(audioData);

% Compute the magnitude of the FFT
magnitude = abs(audioFFT)/N;

% Step 3: Plot the Frequency Spectrum
figure;
plot(frequencies, magnitude);
xlim([0, sampleRate/2]); % We only need to plot up to the Nyquist frequency
title('Frequency Spectrum');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

% Step 3: Find the top 3 frequencies
[sortedMagnitude, sortedIndices] = sort(magnitude, 'descend');
top3Indices = sortedIndices(1:3);
top3Frequencies = frequencies(top3Indices);
top3Magnitudes = sortedMagnitude(1:3);

% Display the top 3 frequencies and their magnitudes
disp('Top 3 Frequencies and their Magnitudes:');
for i = 1:3
    fprintf('Frequency: %.2f Hz, Magnitude: %.2f\n', top3Frequencies(i), top3Magnitudes(i));
end


music=audioplayer(audioData,sampleRate);
play(music);
pause(5);
stop(music);