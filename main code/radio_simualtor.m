clear all;
clc;

% List of channel audio file names
fileNames = [...
    "Ch0_Short_BBCArabic2.wav", ...
    "Ch1_Short_FM9090.wav", ...
    "Ch2_Short_QuranPalestine.wav", ...
    "Ch3_Short_RussianVoice.wav", ...
    "Ch4_Short_SkyNewsArabia.wav"];

ChannelPath = "Channels\";

% Initialize an array of AudioFile objects
audioFiles = AudioFile.empty; % Start with an empty array

% Loop through the file names to create AudioFile objects
for i = 1:length(fileNames)
    fullPath = ChannelPath + fileNames(i); % Build the full path
    if isfile(fullPath) % Check if the file exists
        audioFiles(i) = AudioFile(fullPath); % Append each file
    else
        warning('File not found: %s', fullPath); % Warn if the file does not exist
    end
end

% Call the function to process the array
processAudioFiles(audioFiles);
