function [Selected_Channel,ChannelNumber,Channel_Frequency, RF_BPF] = choose_channel(Channels_IN,maxChannelNumber, fc0, fDelta, BW,Fs)
    % Function to choose a channel and create the corresponding bandpass filter
    % Parameters:
    %   maxChannelNumber - The maximum number of available channels
    %   fc0              - The starting frequency for the carrier (Hz)
    %   fDelta           - The frequency spacing between channels (Hz)
    %   Fs  - The maximum sampling frequency (in Hz) used for filter design
    %
    % Outputs:
    %   ChannelNumber    - The selected channel number
    %   RF_BPF           - The designed bandpass filter for the selected channel
    
    % Ask the user to select a channel
    disp('Select the channel number:');
    for i = 1:maxChannelNumber
        disp([num2str(i), '. Channel ', num2str(i)]);
    end
    
    % Get user input for the channel
    ChannelNumber = input(['Enter the channel number (1-', num2str(maxChannelNumber), '): ']);
    
    % Validate the input
    if ~ismember(ChannelNumber, 1:maxChannelNumber)
        error('Invalid channel number. Please choose a number between 1 and %d.', maxChannelNumber);
    end
    
    % Filter parameters
    FilterOrder = 40;                    % Filter order
    Channel_Frequency = fc0 + (ChannelNumber - 1) * fDelta;  % Carrier frequency (Hz)
    DeltaF = ceil(BW)/2;                       % Bandwidth (Hz)
    
    % Create the bandpass filter
    RF_BPF = createBandPassFilter(Channel_Frequency, Fs, DeltaF,FilterOrder);
    
    % Display the selected channel and filter info
    %fprintf('You selected Channel %d with carrier frequency %.1f kHz.\n', ChannelNumber, Channel_Frequency / 1e3);
    
    %Get the channel
    Selected_Channel = filter_audio_file(Channels_IN,RF_BPF);
end
