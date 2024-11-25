classdef AudioFile
    properties
        Filename          % Name of the file
        SamplingFrequency % Sampling frequency of the audio
        AudioData         % Actual audio data
        duration          % File length
        player            % Object to play the sound file  
    end
    methods
        function obj = AudioFile(filename)
            % Constructor method to initialize the object
            if nargin > 0
                [audioData, fs] = audioread(filename);
                obj.Filename = filename;
                obj.SamplingFrequency = fs;
                obj.AudioData = audioData;
                obj.duration  = length(obj.AudioData) / obj.SamplingFrequency;
                obj.player = audioplayer(obj.AudioData, obj.SamplingFrequency);
            end
        end
        
        function playAudio(obj)
            % Method to play the audio file
            play(obj.player);
        end
        
        function pauseAudio(obj)
            % Method to pause the audio file
            pause(obj.player);
        end
        
        function stopAudio(obj)
            % Method to stop the audio file
            stop(obj.player);
        end
        
        function printAudio(obj)
            % Method to print all the audio file data
            disp(['Filename: ', obj.Filename]);
            disp(['Sampling Frequency: ', num2str(obj.SamplingFrequency), ' Hz']);
            disp(['Audio Duration: ', num2str(obj.getDuration()), ' seconds']);
            disp(obj.AudioData(1:10, :)); % Print the first 10 samples
        end
        
        end
end

