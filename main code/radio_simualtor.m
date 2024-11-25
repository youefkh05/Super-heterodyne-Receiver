clear all;
close all;
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

%read the audio files
channels=read_channels(fileNames,ChannelPath);

%get its data
print_channels_data(channels);

%check the max length and frequency for padding
[maxDuration, maxSamplingFreq, maxLength] = getMaxAudioInfo(channels);

% Display the results
fprintf('Max Duration: %.2f seconds\n', maxDuration);
fprintf('Max Sampling Frequency: %.2f kHz\n', maxSamplingFreq);
fprintf('Max Audio Data Length (number of samples): %d\n', maxLength);

%pad the files 
channels = padAudioFiles(channels, maxLength, maxSamplingFreq);

%plot them and get the bandwidth 
%we multiplay it by 4 to get more than the Nyquist frequency for safety
Total_BW=4*plotChannelSpectrum(channels)+ (length(channels))*60;
pause(3);
close all;

% Display total bandwidth across all channels
fprintf('Total Bandwidth: %.2f kHz\n', Total_BW);

if Total_BW>=maxSamplingFreq
    %we gonna resample the audio files
    maxSamplingFreq=Total_BW;
    fprintf('Max Sampling Frequency: %.2f kHz\n', maxSamplingFreq);
    channels = padAudioFiles(channels, maxLength, maxSamplingFreq);
    
    %check the new max length and frequency
    [maxDuration, maxSamplingFreq, maxLength] = getMaxAudioInfo(channels);
end

%save the padded files
saveChannelsAsWav(channels, "ch_pad", "Channels\Padded");

%plot the padded signals
plotChannelSpectrum(channels);

%AM Modulate (DSB-SC)
multiplexedchannels = AM_Modulate_DSB_SC(channels, maxLength, maxSamplingFreq );

%save the AM Modulate file
saveChannelsAsWav(multiplexedchannels, "ch_AM", "Channels\AM");

%Plot the AM Modulate (DSB-SC) Signal
plotChannelSpectrum(multiplexedchannels);

