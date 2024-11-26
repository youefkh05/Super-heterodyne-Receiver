
function [filtered_file] = filter_audio_file(audio_file_in,filter_in)
    % Function to filter an audio file object using a given filter
    % Parameters:
    %   audio_file_in - Input AudioFile object
    %   filter_in     - Filter object to apply
    % Returns:
    %   filtered_file - A new AudioFile object with filtered audio data
    filtered_file=audio_file_in; %to have the same information
    sampling_freq = audio_file_in.SamplingFrequency * 1000; % Convert kHz to Hz

    audio_signal_out=filter(filter_in, audio_file_in.AudioData);
    % Update the filtered object's properties
    filtered_file.AudioData = audio_signal_out;
    filtered_file.player = audioplayer(audio_signal_out, sampling_freq); % Update player
end