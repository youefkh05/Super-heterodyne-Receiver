% read_channels.m
function [channels] = read_channels(fileNames,ChannelPath)
    
    % Parameters:
    %   audioFiles - Array of AudioFile objects
    
    % Initialize an array of AudioFile objects
    channels = AudioFile.empty; % Start with an empty array

    % Loop through the file names to create AudioFile objects
    for i = 1:length(fileNames)
        fullPath = ChannelPath + fileNames(i); % Build the full path
        if isfile(fullPath) % Check if the file exists
            channels(i) = AudioFile(fullPath); % Append each file
        else
            warning('File not found: %s', fullPath); % Warn if the file does not exist
        end
    end
end