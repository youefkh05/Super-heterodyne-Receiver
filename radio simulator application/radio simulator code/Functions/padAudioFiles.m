function paddedAudioFiles = padAudioFiles(audioFiles, maxLength, maxSamplingFreq)
    % Function to pad the audio files with zeros and resample if necessary
    % so that all audio files have the same length and sample frequency.
    %
    % Parameters:
    %   audioFiles      - Array of AudioFile objects
    %   maxLength       - Maximum length (number of samples) to pad the audio files
    %   maxSamplingFreq - Desired sampling frequency to ensure uniformity
    %
    % Returns:
    %   paddedAudioFiles - Array of AudioFile objects with padded and resampled data

    paddedAudioFiles = audioFiles; % Start with the original array of audio files
    maxSamplingFreq  = ceil(1000*maxSamplingFreq);
    
    % Loop through each AudioFile object
    for i = 1:length(audioFiles)
        % Check and resample if necessary
        if audioFiles(i).SamplingFrequency ~= maxSamplingFreq
            % Resample the audio data to the maximum sample frequency
            newAudioData = resample(audioFiles(i).AudioData, maxSamplingFreq, ceil(1000*audioFiles(i).SamplingFrequency));
            % Update the sampling frequency
            paddedAudioFiles(i).SamplingFrequency = maxSamplingFreq/1000;
            paddedAudioFiles(i).AudioData = newAudioData;
           
        end
        
        % Check if the length of the audio is shorter than the max length
        audioDataLength = length(paddedAudioFiles(i).AudioData);
        if audioDataLength < maxLength
            % Pad with zeros to the right of the audio data
            paddedAudioFiles(i).AudioData(audioDataLength+1:maxLength) = 0;
            paddedAudioFiles(i).duration  = 0.001*length(paddedAudioFiles(i).AudioData) / paddedAudioFiles(i).SamplingFrequency;
        end
    end
end
