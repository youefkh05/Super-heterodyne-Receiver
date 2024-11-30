function LPF = createLowPassFilter(Fc, Fs, FilterOrder)
    % createLowPassFilter - Designs a tunable low-pass filter
    %
    % Syntax:
    %   LPF = createLowPassFilter(Fc, Fs, FilterOrder)
    %
    % Inputs:
    %   Fc - Cutoff frequency (Hz)
    %   Fs - Sampling frequency (Hz)
    %   FilterOrder - Filter order
    %
    % Output:
    %   LPF - Designed low-pass filter object
    
    % Add the Filters folder to the MATLAB path temporarily (optional)
    addpath('Filters');
    
    % Normalized cutoff frequency (relative to Nyquist frequency Fs/2)
    F3dB = Fc / (Fs / 2);
    
    % Validate frequency values
    if F3dB <= 0 || F3dB >= 1
        error('Cutoff frequency must be within the range (0, Fs/2).');
    end
    
    % Create the filter specification object
    LPF_Spec = fdesign.lowpass('N,F3dB', FilterOrder, F3dB);
    
    % Design the filter using the new method (Butterworth filter)
    LPF = design(LPF_Spec, 'butter');
    
    % Visualize the filter's frequency response (optional)
    % fvtool(LPF);
end
