% play_channels.m
function play_channels(channles,duration)
    % Function to process an array of AudioFile objects
    % Parameters:
    %   audioFiles - Array of AudioFile objects
    %   duration   - play for a duration

    % Loop through each AudioFile object
    for i = 1:length(channles)
        channles(i).playAudio();  % Play the audio file
        pause(duration);                   % Short delay (e.g., for playback)
        channles(i).stopAudio();  % Stop the playback
    end
end