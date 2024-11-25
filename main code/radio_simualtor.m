clear all;
clc;

% Add the Functions folder to the MATLAB path temporarily
addpath('Functions');

% List of channel audio file names
fileNames = [...
    "Ch0_Short_BBCArabic2.wav", ...
    "Ch1_Short_FM9090.wav", ...
    "Ch2_Short_QuranPalestine.wav", ...
    "Ch3_Short_RussianVoice.wav", ...
    "Ch4_Short_SkyNewsArabia.wav"];

ChannelPath = "Channels\";

channels=read_channels(fileNames,ChannelPath);

print_channels_data(channels);


[maxDuration, maxSamplingFreq, maxLength] = getMaxAudioInfo(channels);

% Display the results
fprintf('Max Duration: %.2f seconds\n', maxDuration);
fprintf('Max Sampling Frequency: %.2f Hz\n', maxSamplingFreq);
fprintf('Max Audio Data Length (number of samples): %d\n', maxLength);

channels = padAudioFiles(channels, maxLength, maxSamplingFreq);

%play_channels(channels,4);

saveChannelsAsWav(channels, "ch_pad", "Channels\Padded");

plotChannelSpectrum(channels);
