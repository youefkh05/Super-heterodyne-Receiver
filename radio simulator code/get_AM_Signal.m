function [AM_Modulated_Signal_out, Fs_out] = get_AM_Signal(filepath)
    % Function to load AM modulated signal from a file
    % Inputs:
    %   filepath - The path to the file containing the AM modulated signal and sample rate
    % Outputs:
    %   AM_Modulated_Signal_out - The AM modulated signal
    %   Fs_out - The sampling frequency of the signal
    
    % Load the saved audio file and sample rate from the specified filepath
    load(filepath);  % This will load the 'AM_Modulated_Signal' and 'Fs' variables
    
    % Assign output variables
    AM_Modulated_Signal_out = AM_Modulated_Signal;
    Fs_out = Fs;
end
