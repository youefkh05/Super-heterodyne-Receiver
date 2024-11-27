function [Filtered_Audio_File, IF_BPF] = if_stage(Input_Audio_File, WIF,BW,Fs)
    % Function to process the IF stage with a band-pass filter
    % Parameters:
    %   InputSignal - The input signal to be filtered
    %   omega_IF    - Intermediate frequency (rad/sec)
    %   Fs          - Sampling frequency (Hz)
    %
    % Outputs:
    %   FilteredSignal - The filtered signal at the IF stage
    %   IF_BPF         - The band-pass filter object used
    
    Filtered_Audio_File   =   Input_Audio_File;  %to have the same information
    
    
    % Filter parameters
    FilterOrder = 40;  % Filter order (adjust as needed)
    DeltaF = BW/ 2;  % Half the bandwidth
    
    % Create the bandpass filter centered at omega_IF
    IF_BPF = createBandPassFilter(WIF, Fs, DeltaF, FilterOrder);
    
    % Apply the filter to the input signal
    FilteredSignal = filter(IF_BPF, Input_Audio_File.AudioData);
    
    % Update the Filtered object's properties
    Filtered_Audio_File.AudioData =  FilteredSignal;
    Filtered_Audio_File.player = audioplayer( FilteredSignal, Fs); % Update player
    
end
