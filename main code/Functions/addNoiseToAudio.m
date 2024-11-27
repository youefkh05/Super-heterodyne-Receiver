function Noisy_Audio_File = addNoiseToAudio(Input_Audio_File, SNR_dB, Fs)
    % addNoiseToAudio - Adds AWGN noise to an audio signal and plays the result.
    %
    % Syntax:
    %   Noisy_Audio_File = addNoiseToAudio(Input_Audio_File, SNR_dB)
    %
    % Inputs:
    %   Input_Audio_File - Struct with the input audio data and metadata
    %                      (e.g., AudioData and sampling frequency Fs)
    %   SNR_dB           - Desired Signal-to-Noise Ratio in dB
    %
    % Output:
    %   Noisy_Audio_File - Struct containing noisy audio data and metadata
    
    % Extract the audio data and sampling frequency
    AudioData = Input_Audio_File.AudioData;
    
    % Generate the noisy signal using AWGN
    NoisySignal = awgn(AudioData, SNR_dB, 'measured');
    
    % Create the output noisy audio file struct
    Noisy_Audio_File = Input_Audio_File;  % Copy input structure
    Noisy_Audio_File.AudioData = NoisySignal;  % Update with noisy signal
    Noisy_Audio_File.player = audioplayer(NoisySignal, Fs); % Update player
    
    
end
