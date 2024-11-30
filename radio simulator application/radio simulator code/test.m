clear;
clc;
% Add the Functions and Filters folder to the MATLAB path temporarily
addpath('Functions');
addpath('Filters');
[AM_Modulated_Signal, Fs] = get_AM_Signal("Channels\AM\AM_Modulated_Channel.mat");
plotChannelSpectrum(AM_Modulated_Signal, "AM DSB SC", 0);
ch_freq = 150e3;
rf = 1;

% Correctly capture multiple outputs from the radio function
[AM_Modulated_Signal_RF_Filter, Bass_Band_Channel, RF_BPF, IF_BPF, Bass_Band_Filter] = radio(AM_Modulated_Signal, ch_freq, Fs, rf);

%{
plotFilter(RF_BPF, Fs, "RF");
plotFilter(IF_BPF, Fs, "IF");
plotFilter(Bass_Band_Filter, Fs, "Bass_Band_Filter");
%}