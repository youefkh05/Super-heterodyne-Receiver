% print_channels_data.m
function print_channels_data(channels)
    % Function to process an array of AudioFile objects
    % Parameters:
    %   channels - Array of AudioFile objects

    % Loop through each AudioFile object
    for i = 1:length(channels)
        fprintf('channel Audio File %d Details:\n', i);
        channels(i).printAudio(); % Print details of the file
    end
end