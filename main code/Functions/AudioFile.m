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
                
                % Convert to mono if stereo
                if size(audioData, 2) == 2
                    mono_audioData = sum(audioData, 2); % Sum the two channels to get a mono signal
                end
                
                obj.Filename = filename;
                obj.SamplingFrequency = fs;
                obj.AudioData = mono_audioData;
                obj.duration  = length(obj.AudioData) / obj.SamplingFrequency;
                obj.player = audioplayer(obj.AudioData, obj.SamplingFrequency);
            end
        end
        
        function playAudio(obj)
            % Method to play the audio file
            if ~isempty(obj.player)
                play(obj.player);
            else
                disp('No audio data to play.');
            end
        end
        
        function pauseAudio(obj)
            % Method to pause the audio file
            if ~isempty(obj.player)
                pause(obj.player);
            else
                disp('No audio data to pause.');
            end
        end
        
        function stopAudio(obj)
            % Method to stop the audio file
            if ~isempty(obj.player)
                stop(obj.player);
            else
                disp('No audio data to stop.');
            end
        end
        
        function printAudio(obj)
            % Method to print all the audio file data
            if ~isempty(obj.AudioData)
                disp(['Filename: ', obj.Filename]);
                disp(['Sampling Frequency: ', num2str(obj.SamplingFrequency), ' Hz']);
                disp(['Audio Duration: ', num2str(obj.duration), ' seconds']);
                % Optional: Display first few samples of audio data
                disp('First 10 samples of Audio Data:');
                disp(obj.AudioData(1:10));
            else
                disp('No audio data to print.');
            end
        end
        
        end
end

