
% Super_heterodyne_Receiver.m
function Super_heterodyne_Receiver(audioFiles)
    % Function to process an array of AudioFile objects
    % Parameters:
    %   audioFiles - Array of AudioFile objects

    % Loop through each AudioFile object
    for i = 1:length(audioFiles)
        audioFiles(i).playAudio();  % Play the audio file
        pause(5);                   % Short delay (e.g., for playback)
        audioFiles(i).stopAudio();  % Stop the playback
    end
end
