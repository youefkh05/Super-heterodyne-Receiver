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
    Fc_Norm = Fc / (Fs / 2);
    
    % Validate frequency values
    if Fc_Norm <= 0 || Fc_Norm >= 1
        error('Cutoff frequency must be within the range (0, Fs/2).');
    end
    
    % Create the filter specification object
    LPF_Spec = fdesign.lowpass('N,Fc', FilterOrder, Fc_Norm);
    
    % Design the filter using a Butterworth filter design
    LPF = design(LPF_Spec, 'butter');
    
    % Visualize the filter's frequency response (optional)
    %fvtool(LPF);
end
