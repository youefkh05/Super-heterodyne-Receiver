function multiplexed_Audio_Signal = AM_Modulate_DSB_SC(channels, Length, sampleFreq)
    % Function to perform AM modulation (DSB-SC) and return multiplexed signal
    % Parameters:
    %   channels - Array of audio signals (cell array of vectors)
    %   sampleFreq - Sampling frequency of the audio signals (scalar)
    % Returns:
    %   multiplexedSignal - Combined FDM signal
    
    % Parameters for modulation
    baseCarrierFreq = 100e+03; % Base carrier frequency in kHz
    deltaFreq = 50e+03;        % Frequency increment between carriers in kHz

    % Time vector based on the sample frequency and signal length
    %Length = max(cellfun(@length, channels)); % Ensure all signals are the same length
    Ts=1/sampleFreq;    %Sample Time          
    t=[0:Ts:Length*Ts-Ts];   %Time vector

    % Initialize the multiplexed signal
    multiplexedSignal = zeros(1, Length);

    % Loop through each channel and modulate it
    for n = 1:length(channels)
        % Get the current channel signal
        signal = channels(n).AudioData;
        
        % Carrier frequency for this channel
        carrierFreq = baseCarrierFreq + (n-1) * deltaFreq;

        % Generate the carrier signal
        carrier = cos(2 * pi * carrierFreq * t)';

        % Perform DSB-SC modulation
        modulatedSignal = signal .* carrier;

        % Add the modulated signal to the multiplexed signal
        multiplexedSignal = multiplexedSignal + modulatedSignal';
    end
    
    %same information
    multiplexed_Audio_Signal=AudioFile("Channels\Padded\ch_pad_3.wav"); 
    multiplexedSignal=transpose(multiplexedSignal);
    multiplexed_Audio_Signal.AudioData=multiplexedSignal;
end
