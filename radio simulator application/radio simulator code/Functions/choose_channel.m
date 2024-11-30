function [Selected_Channel, RF_BPF] = choose_channel(Channels_IN, Channel_Frequency, BW, Fs)
    % Function to select a channel and create the corresponding bandpass filter
    % Parameters:
    %   Channels_IN      - Input signal channels
    %   Channel_Frequency - The center frequency of the channel in Hz
    %   BW                - The bandwidth of the channel in Hz
    %   Fs                - The sampling frequency in Hz
    %
    % Outputs:
    %   Selected_Channel - The filtered channel signal
    %   RF_BPF            - The bandpass filter for the selected channel
    
    % Filter parameters
    FilterOrder = 40;                   % Filter order
    DeltaF = ceil(BW) / 2;              % Bandwidth divided by 2 for the filter design
    
    % Create the bandpass filter for the given channel frequency
    RF_BPF = createBandPassFilter(Channel_Frequency, Fs, DeltaF, FilterOrder);
    
    % Apply the filter to the input signal to extract the selected channel
    Selected_Channel = filter_audio_file(Channels_IN, RF_BPF);
    
    % Optionally, you can display the selected frequency and filter information
    fprintf('Selected Channel with carrier frequency %.1f kHz.\n', Channel_Frequency / 1e3);
end
