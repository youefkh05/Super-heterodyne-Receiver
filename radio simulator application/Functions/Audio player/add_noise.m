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

% Parameters
noiseLevel = 0.01; % Adjust this value to set the noise level

% Generate different types of noise
whiteNoise = noiseLevel * randn(size(audioData));
pinkNoise = noiseLevel * pinknoise(length(audioData));
violetNoise = noiseLevel * diff([0; diff([0; randn(length(audioData), 1)])]);

noisyAudiodata = audioData + whiteNoise + pinkNoise +violetNoise;
splitStr = strsplit(file, '.');
filename = splitStr{1};

filename=string(filename);
savedfilep=path+filename+"noised.wav"; %file path
audiowrite(savedfilep, noisyAudiodata, sampleRate);