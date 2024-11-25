clear all;
close all;
clc;

% Add the Functions folder to the MATLAB path temporarily
addpath('Functions');

% Create an AudioFile object
audioFile = AudioFile("Channels\Padded\ch_pad_3.wav");

% Play the audio
audioFile.playAudio();

% Print audio details
audioFile.printAudio();
getBandwidth(audioFile);

pause(2);

audioFile.pauseAudio();






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
fprintf('Max Sampling Frequency: %.2f Hz\n', maxSamplingFreq);
fprintf('Max Audio Data Length (number of samples): %d\n', maxLength);

%pad the files 
channels = padAudioFiles(channels, maxLength, maxSamplingFreq);

%play_channels(channels,4);

%plot them and get the bandwidth 
%we multiplay it by 3 to get more than the Nyquist frequency for safety
Total_BW=2.3*plotChannelSpectrum(channels)+ length(channels)*25e+03;
close all;

% Display total bandwidth across all channels
fprintf('Total Bandwidth: %.2f Hz\n', Total_BW);

if Total_BW>=maxSamplingFreq/1000
    %we gonna resample the audio files
    maxSamplingFreq=Total_BW;
    fprintf('Max Sampling Frequency: %.2f Hz\n', maxSamplingFreq);
    channels = padAudioFiles(channels, maxLength, maxSamplingFreq);
    
    %check the new max length and frequency
    [maxDuration, maxSamplingFreq, maxLength] = getMaxAudioInfo(channels);
end

%save the padded files
saveChannelsAsWav(channels, "ch_pad", "Channels\Padded");

plotChannelSpectrum(channels);

%AM Modulate (DSB-SC)
multiplexedchannels = AM_Modulate_DSB_SC(channels, maxLength, maxSamplingFreq );

%save the AM Modulate file
saveChannelsAsWav(multiplexedchannels, "ch_AM", "Channels\AM");

plotChannelSpectrum(multiplexedchannels);

