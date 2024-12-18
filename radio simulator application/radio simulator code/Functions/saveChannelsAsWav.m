function [Channels_Out]=saveChannelsAsWav(channels, filename, savePath)
    % Function to save each audio channel as a .wav file in a specified directory
    % Parameters:
    %   channels  - Array of AudioFile objects (audio channels)
    %   filename  - The base name for each saved file (e.g., 'audio_data')
    %   savePath  - The directory where the files should be saved
    
    maxSamplingFreq=48e3; %the max for most laptops are 48kHz 
    
    % Ensure the savePath exists, if not create the directory
    if ~exist(savePath, 'dir')
        mkdir(savePath);
    end
    
    Channels_Out=channels;
    
    % Loop through each AudioFile object in the channels array
    for i = 1:length(channels)
        % Create the output filename for each channel (e.g., 'audio_data_1.wav')
        outputFilename = fullfile(savePath, sprintf('%s_%d.wav', filename, i));
        
        Channels_Out(i).Filename=outputFilename;
        
        % Get the audio data and sampling frequency from the AudioFile object
        samplingFreq = ceil(1000*channels(i).SamplingFrequency);
        
        %   Make sure to save it with the proper sample rate 
        if(samplingFreq>maxSamplingFreq)
            % Resample the audio data to the maximum sample frequency
            audioData = resample(channels(i).AudioData, maxSamplingFreq, samplingFreq);
            % Update the sampling frequency
            samplingFreq=maxSamplingFreq;
        else
            %nothing changes
            audioData = channels(i).AudioData;  % Assuming 'audioData' holds the raw audio data
        end

        % Normalize the audio data to be within the range [-1, 1]
        audioData = audioData / max(abs(audioData));  % Normalize audio data
        
        % Save the audio data to a .wav file
        audiowrite(outputFilename, audioData, samplingFreq);
        
        Channels_Out(i).player=audioplayer(audioData, samplingFreq);
        
        % Display a message indicating the file was saved
        fprintf('Saved %s\n', outputFilename);
    end
end
