function [AM_Modulated_Signal_RF_Filter,IF_Channel_Filtered, Bass_Band_Channel, RF_BPF, IF_BPF, Bass_Band_Filter] =...
    radio(AM_Modulated_Signal, channel_frequency, Fs, RF_flag)
    % Function to simulate a radio receiver with stages for RF, IF, and Baseband
    % Inputs:
    %   AM_Modulated_Signal - Input AM modulated signal
    %   channel_frequency - Frequency of the desired channel (50-350 kHz)
    %   Fs - Sampling frequency
    %   RF_flag - Flag to use RF filter (1 = Yes, 0 = No)
    
    % Step 1: Set filter parameters for RF stage
    Fc = channel_frequency;                % Channel frequency in Hz
    fDelta = 50e3;                          % Channel spacing in Hz
    Channel_BandWidth = 40e3;               % Bandwidth of each channel in Hz
    
    % Use the 'choose_channel' function to select the channel
    [AM_Modulated_Signal_RF_Filter, RF_BPF] = ...
            choose_channel(AM_Modulated_Signal,channel_frequency, Channel_BandWidth, Fs);
    
    % Step 2: Apply RF Filter if RF_flag is set
    if RF_flag == 1
        
        % Visualize the frequency response of the RF filter
        %plotFilter(RF_BPF, Fs, "Frequency Response of RF Bandpass Filter");
    else
        % If RF flag is not set, no RF filter is applied
        AM_Modulated_Signal_RF_Filter = AM_Modulated_Signal;
    end
    
    % Step 3: Apply IF Filter (Intermediate Frequency Stage)
    WIF = 25e3;  % IF frequency in Hz
    
    IF_Channel = mixer(AM_Modulated_Signal_RF_Filter, channel_frequency, WIF ,Fs);
    
    %IF Filter
    [IF_Channel_Filtered,IF_BPF]      =   ...
         if_stage(IF_Channel, WIF,Channel_BandWidth,Fs);
    
    % Visualize the frequency response of the IF filter
    %plotFilter(IF_BPF, Fs, "Frequency Response of IF Bandpass Filter");
    
    % Step 4: Apply Baseband Filter (Baseband Stage)
    [Bass_Band_Channel, Bass_Band_Filter] = baseband_detection(IF_Channel_Filtered, WIF, Fs);
    
    % Visualize the frequency response of the Bass Band filter
    %plotFilter(Bass_Band_Filter, Fs, "Frequency Response of Bass Band Low Pass Filter");
    
    % Step 5: Save and Visualize Receiver Signals
    %plotReceiver(AM_Modulated_Signal_RF_Filter, IF_Channel_Filtered, Bass_Band_Channel);
    
    % Save signals as WAV files
    %AM_Modulated_Signal_RF_Filter = saveChannelsAsWav(AM_Modulated_Signal_RF_Filter, "ch_RF_Filter", "Channels\RF");
    %IF_Channel_Filtered = saveChannelsAsWav(IF_Channel_Filtered, "IF_Channel", "Channels\IF");
    Bass_Band_Channel = saveChannelsAsWav(Bass_Band_Channel, "Bass_Band_Channel", "Channels\Bass_Band");
end
