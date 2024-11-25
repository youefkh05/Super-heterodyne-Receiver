function saveChannelsAsWav(channels, filename, savePath)
    % Function to save each audio channel as a .wav file in a specified directory
    % Parameters:
    %   channels  - Array of AudioFile objects (audio channels)
    %   filename  - The base name for each saved file (e.g., 'audio_data')
    %   savePath  - The directory where the files should be saved
    
    % Ensure the savePath exists, if not create the directory
    if ~exist(savePath, 'dir')
        mkdir(savePath);
    end
    
    % Loop through each AudioFile object in the channels array
    for i = 1:length(channels)
        % Create the output filename for each channel (e.g., 'audio_data_1.wav')
        outputFilename = fullfile(savePath, sprintf('%s_%d.wav', filename, i));
        
        % Get the audio data and sampling frequency from the AudioFile object
        audioData = channels(i).AudioData;  % Assuming 'audioData' holds the raw audio data
        samplingFreq = ceil(1000*channels(i).SamplingFrequency);  % Assuming 'SamplingFrequency' holds the sample rate
        
        % Normalize the audio data to be within the range [-1, 1]
        audioData = audioData / max(abs(audioData));  % Normalize audio data
        
        % Save the audio data to a .wav file
        audiowrite(outputFilename, audioData, samplingFreq);
        
        % Display a message indicating the file was saved
        fprintf('Saved %s\n', outputFilename);
    end
end
