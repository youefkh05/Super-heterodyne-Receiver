clear all;
close all;
clc;

% Add the Functions and Filters folder to the MATLAB path temporarily
addpath('Functions');
addpath('Filters');
load RF_Band_Pass_Filter;

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
%we multiplay it by 7 to get more than the Nyquist frequency for safety
Total_BW=7*plotChannelSpectrum(channels);
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
FDM = AM_Modulate_DSB_SC(channels, maxLength, maxSamplingFreq );

%save the AM Modulate file
saveChannelsAsWav(FDM, "ch_AM", "Channels\AM");

%Plot the AM Modulate (DSB-SC) Signal
plotChannelSpectrum(FDM);

channelNumber = input('Enter the channel number (1-5): ');
if ~ismember(channelNumber, 1:5)
    error('Invalid channel number. Please choose a number between 1 and 5.');
end


% Filter parameters
FilterOrder = 40;      % Filter order
Fc = 100e3 + (channelNumber - 1)*50e3;            % Carrier frequency (Hz)
Fs=ceil(1000*maxSamplingFreq);
DeltaF = 20e3;         % Bandwidth (Hz)

RF_BPF = createBandPassFilter(Fc, ceil(1000*maxSamplingFreq), DeltaF);

% Visualize the new filter
fprintf('You selected Channel %d with carrier frequency %.1f kHz.\n', channelNumber, Fc / 1e3);
fvtool(RF_BPF)  % Frequency response for new carrier frequency

% Filter to get the channel desired
FDM_Filter = filter_audio_file(FDM,RF_BPF);

%Plot the Filter AM Modulate (DSB-SC) Signal
plotChannelSpectrum(FDM_Filter);


% Remove added paths
rmpath('Functions');
rmpath('Filters');
