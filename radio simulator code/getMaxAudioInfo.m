function [maxDuration, maxSamplingFreq, maxLength] = getMaxAudioInfo(audioFiles)
    % Function to get the maximum duration and maximum sampling frequency
    % from an array of AudioFile objects.
    %
    % Parameters:
    %   audioFiles - Array of AudioFile objects
    %
    % Returns:
    %   maxDuration - Maximum duration found across all audio files
    %   maxSamplingFreq - Maximum sampling frequency found across all audio files
    %   maxLength - Maximum length of the audio data (number of samples)

    maxDuration     =   0;     % Initialize maxDuration
    maxSamplingFreq =   0;     % Initialize maxSamplingFreq
    maxLength       =   0;     % Initialize MAXLength 
    
    % Loop through each AudioFile object
    for i = 1:length(audioFiles)
        % Check for max duration
        if audioFiles(i).duration > maxDuration
            maxDuration = audioFiles(i).duration;
        end
        
        % Check for max sampling frequency
        if audioFiles(i).SamplingFrequency > maxSamplingFreq
            maxSamplingFreq = audioFiles(i).SamplingFrequency;
        end
        
        % Check for max Length (number of samples in AudioData)
        if length(audioFiles(i).AudioData) > maxLength
            maxLength = length(audioFiles(i).AudioData);
        end
    end
end
