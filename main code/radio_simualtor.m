clear all;
close all;
clc;

% Add the Functions and Filters folder to the MATLAB path temporarily
addpath('Functions');
addpath('Filters');
load RF_Band_Pass_Filter;

% List of channel audio file names
fileNames = [...
    "Ch0_Short_QuranPalestine.wav", ... 
    "Ch1_Short_FM9090.wav", ...
    "Ch2_Short_BBCArabic2.wav", ...
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

%Add noise (Optional)
Noise = input('Do you Want to add noise?\n Yes: y  No: anything else \n', 's'); % Specify 's' for string input
 
%check Noise
if Noise == "y"
    % Get user input SNR
    SNR_dB = input(["How Much SNR (db) ?\n"]);
    
    %add the noise
    fprintf('Adding Noise ...\n');
    Fs=ceil(1000*maxSamplingFreq);
    FDM = addNoiseToAudio(FDM, SNR_dB, Fs);
end

%save the AM Modulate file
saveChannelsAsWav(FDM, "ch_AM", "Channels\AM");

%Plot the AM Modulate (DSB-SC) Signal
plotChannelSpectrum(FDM);

% Filter parameters
Fc = 100e3 ;            % Carrier frequency (Hz)
fDelta=50e3;            % Channels Distance
Fs=ceil(1000*maxSamplingFreq);
Channel_BandWidth = 40e3;         % Bandwidth (Hz)

% Signals Parameters
maxChannelNumber = 5;

% Filter to get the channel desired
[FDM_RF_Filter,ChannelNumber, Channel_Frequency, RF_BPF] = ...
    choose_channel(FDM,maxChannelNumber, Fc, fDelta, ...
                 Channel_BandWidth,Fs);
             
%Remove RF Fiter (Optional)             
RF_Filter =  input("Do you Want to add RF Filter?\n"+...
"Yes: y  No: anything else \n", 's'); % Specify 's' for string input
if RF_Filter == "y"
    % Visualize the new filter
    fprintf('You selected Channel %d with carrier frequency %.1f kHz.\n', ChannelNumber, Channel_Frequency / 1e3);
    fvtool(RF_BPF)  % Frequency response for new carrier frequency
else
    FDM_RF_Filter = FDM;
end


%Plot And save the Filter AM Modulate (DSB-SC) Signal
plotChannelSpectrum(FDM_RF_Filter);
saveChannelsAsWav(FDM_RF_Filter, "ch_RF_Filter", "Channels\RF");

%IF Stage
WIF = 25e3;  %   25kHz as intended

%Add offset (Optional)
offset = input('Do you Want to add offset?\n Yes: y  No: anything else \n', 's'); % Specify 's' for string input
 
%check offset
if offset == "y"
    % Get user input offset
    offset_frequency = input(["What's your offset (hz) ?\n"]);
    
    %add the offset
    fprintf('Adding Offset ...\n');
    IF_Channel = mixer(FDM_RF_Filter, Channel_Frequency, WIF + offset_frequency,Fs);  
else
    %no offset
    IF_Channel = mixer(FDM_RF_Filter, Channel_Frequency, WIF ,Fs);  
end

%IF Filter
[IF_Channel_Filtered,IF_BPF]      =   ...
    if_stage(IF_Channel, WIF,Channel_BandWidth,Fs);

% Frequency response for IF Band Pass Fileter
fvtool(IF_BPF); 

%Plot and save the IF_Channel Signal
plotChannelSpectrum(IF_Channel_Filtered);
saveChannelsAsWav(IF_Channel_Filtered, "IF_Channel", "Channels\IF");

%Bass Band Stage
[Bass_Band_Channel, Bass_Band_Filter] = baseband_detection(IF_Channel_Filtered, WIF, Fs);

% Frequency response for Bass_Band Low Pass Fileter
fvtool(Bass_Band_Filter); 

%Plot and save the Bass_Band_Channel Signal
plotChannelSpectrum(Bass_Band_Channel);
saveChannelsAsWav(Bass_Band_Channel, "Bass_Band_Channel", "Channels\Bass_Band");


% Remove added paths
rmpath('Functions');
rmpath('Filters');
