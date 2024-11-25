clear all;
clc;

% Add the Functions folder to the MATLAB path temporarily
addpath('D:/project/Communication Radio/Super-heterodyne-Receiver/main code/Functions');

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


% Call the function to process the array
Super_heterodyne_Receiver(channels);
