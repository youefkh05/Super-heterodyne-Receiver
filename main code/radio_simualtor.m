clear;
clc;


% Create an instance of the AudioFile class
audio = AudioFile("Channels\Ch0_Short_BBCArabic2.wav");


% Play the audio
audio.playAudio();

% Pause the audio after 5 seconds
pause(5);
audio.pauseAudio();

% Print audio information and first 10 samples
audio.printAudio();

% Stop the audio
audio.stopAudio();


%{


path="Channels\";
file="Ch1_Short_FM9090.wav";



% Construct full file path
%mp = fullfile(path, file);
mp=path+file;

% Read the audio file
[oy, f] = audioread(mp);    

% Create audioplayer object
om = audioplayer(oy, f);

% Play the audio
play(om);
 % Display the sampling frequency
fprintf('The sampling frequency of the selected audio file is %d Hz.\n', f);


% Pause for 5 seconds (or adjust based on the length of your audio)
pause(5);

% Stop the playback
stop(om);
disp('Playback stopped.');
%}

