clear all;
close all;
clc;

% Add the Functions and Filters folder to the MATLAB path temporarily
addpath('Functions');
addpath('Filters');
load RF_Band_Pass_Filter; % Load predefined RF Band-Pass Filter

% List of channel audio file names
fileNames = [...
    "Ch0_Short_QuranPalestine.wav", ... 
    "Ch1_Short_FM9090.wav", ...
    "Ch2_Short_BBCArabic2.wav", ...
    "Ch3_Short_RussianVoice.wav", ...
    "Ch4_Short_SkyNewsArabia.wav"];

ChannelPath = "Channels\";

% Step 1: Load and visualize channel data
channels = read_channels(fileNames, ChannelPath);   % Read audio files into 'channels' structure
print_channels_data(channels);                      % Display details of each channel
plotChannelSpectrum(channels, "Channel", 1);        % Plot spectrum of the channels

% Step 2: Determine max duration, sampling frequency, and length
[maxDuration, maxSamplingFreq, maxLength] = getMaxAudioInfo(channels);

% Display the results
fprintf('Max Duration: %.2f seconds\n', maxDuration);
fprintf('Max Sampling Frequency: %.2f kHz\n', maxSamplingFreq);
fprintf('Max Audio Data Length (number of samples): %d\n', maxLength);

% Step 3: Pad audio files to ensure equal lengths and uniform sampling rate
channels = padAudioFiles(channels, maxLength, maxSamplingFreq);
Total_BW = 7 * plotChannelSpectrum(channels, "Channel", 1);     % Calculate total bandwidth

% Display total bandwidth across all channels
fprintf('Total Bandwidth: %.2f kHz\n', Total_BW);

% Ensure the sampling frequency covers the required bandwidth
if Total_BW>=maxSamplingFreq
    %we gonna resample the audio files
    maxSamplingFreq=Total_BW;
    fprintf('Max Sampling Frequency: %.2f kHz\n', maxSamplingFreq);
    channels = padAudioFiles(channels, maxLength, maxSamplingFreq);
    
    %check the new max length and frequency
    [maxDuration, maxSamplingFreq, maxLength] = getMaxAudioInfo(channels);
end

% Save padded audio files
saveChannelsAsWav(channels, "ch_pad", "Channels\Padded");
plotChannelSpectrum(channels, "Padded Channel", 1);         % Visualize padded signals

% Step 4: AM Modulation (DSB-SC)
AM_Modulated_Signal = AM_Modulate_DSB_SC(channels, maxLength, maxSamplingFreq );

% Optional Step: Add Noise
Noise = input('Do you Want to add noise?\n Yes: y  No: anything else \n', 's'); 
if Noise == "y"
    % Get user input SNR
    SNR_dB = input(["How Much SNR (db) ?\n"]);
    
    %add the noise
    fprintf('Adding Noise ...\n');
    Fs=ceil(1000*maxSamplingFreq);
    AM_Modulated_Signal = addNoiseToAudio(AM_Modulated_Signal, SNR_dB, Fs);
end

% Save and plot the modulated signal
saveChannelsAsWav(AM_Modulated_Signal, "ch_AM", "Channels\AM");
plotChannelSpectrum(AM_Modulated_Signal, "AM DSB SC", 0);

% Step 5: RF Stage - Select a Channel
% Filter parameters
Fc = 100e3 ;                        % Carrier frequency in Hz
fDelta=50e3;                        % Channel spacing in Hz
Fs=ceil(1000*maxSamplingFreq);      % Sampling frequency in Hz
Channel_BandWidth = 40e3;            % Bandwidth of each channel in Hz

% Signals Parameters
maxChannelNumber = length(channels);

% Filter to get the channel desired
[AM_Modulated_Signal_RF_Filter,ChannelNumber, Channel_Frequency, RF_BPF] = ...
    choose_channel(AM_Modulated_Signal,maxChannelNumber, Fc, fDelta, ...
                 Channel_BandWidth,Fs);
             
% Optional Step: Remove RF Filter           
RF_Filter =  input("Do you Want to add RF Filter?\n"+...
"Yes: y  No: anything else \n", 's'); % Specify 's' for string input
if RF_Filter == "y"
    % Visualize the new filter
    fprintf('You selected Channel %d with carrier frequency %.1f kHz.\n', ChannelNumber, Channel_Frequency / 1e3);
    
    %Plot the frequency response of RF Bandpass Filter
    plotFilter(RF_BPF, Fs, "Frequency Response of RF Bandpass Filter");
else
    AM_Modulated_Signal_RF_Filter = AM_Modulated_Signal;
end

% Step 6: IF Stage
WIF = 25e3;  % Intermediate Frequency (IF) in Hz

% Optional Step: Add offset to IF
offset = input('Do you Want to add offset?\n Yes: y  No: anything else \n', 's'); % Specify 's' for string input
if offset == "y"
    % Get user input offset
    offset_frequency = input(["What's your offset (hz) ?\n"]);
    
    %add the offset
    fprintf('Adding Offset ...\n');
    IF_Channel = mixer(AM_Modulated_Signal_RF_Filter, Channel_Frequency, WIF + offset_frequency,Fs);  
else
    %no offset
    IF_Channel = mixer(AM_Modulated_Signal_RF_Filter, Channel_Frequency, WIF ,Fs);  
end

%IF Filter
[IF_Channel_Filtered,IF_BPF]      =   ...
    if_stage(IF_Channel, WIF,Channel_BandWidth,Fs);

%Plot the frequency response of IF Bandpass Filter
plotFilter(IF_BPF, Fs, "Frequency Response of IF Bandpass Filter");

% Step 7: Baseband Stage
[Bass_Band_Channel, Bass_Band_Filter] = baseband_detection(IF_Channel_Filtered, WIF, Fs);

%Plot the frequency response of Bass_Band Low Pass Fileter
plotFilter(Bass_Band_Filter, Fs, "Frequency Response of Bass Band Low Pass Filter");

% Step 8: Save and Visualize Receiver Signals
plotReceiver(AM_Modulated_Signal_RF_Filter, IF_Channel_Filtered, Bass_Band_Channel);

%Save as Wav
saveChannelsAsWav(AM_Modulated_Signal_RF_Filter, "ch_RF_Filter", "Channels\RF");
saveChannelsAsWav(IF_Channel_Filtered, "IF_Channel", "Channels\IF");
saveChannelsAsWav(Bass_Band_Channel, "Bass_Band_Channel", "Channels\Bass_Band");

% Clean up paths
rmpath('Functions');
rmpath('Filters');

% End of the code
fprintf('Processing complete. All stages executed and signals saved.\n');
