clear;
clc;

% Open file selection dialog and filter for .wav files
[file, path] = uigetfile('*.wav', 'Select a WAV file');
if isequal(file, 0) % Check if user canceled the file dialog
    disp('No file selected.');
    return;
end

% Construct full file path
mp = fullfile(path, file);

% Read the audio file
[oy, f] = audioread(mp);    

% Create audioplayer object
om = audioplayer(oy, f);

% Play the audio
play(om);

% Pause for 5 seconds (or adjust based on the length of your audio)
pause(5);

% Stop the playback
stop(om);
disp('Playback stopped.');
