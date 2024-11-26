function RF_BPF = createBandPassFilter(Fc, Fs, DeltaF)
    % createBandPassFilter - Designs a tunable band-pass filter
    %
    % Syntax:
    %   RF_BPF = createBandPassFilter(Fc, Fs, DeltaF)
    %
    % Inputs:
    %   Fc - Carrier frequency (Hz)
    %   Fs - Sampling frequency (Hz)
    %   DeltaF - Bandwidth (Hz)
    %
    % Output:
    %   RF_BPF - Designed band-pass filter object
    
    % Add the Functions and Filters folder to the MATLAB path temporarily
    addpath('Filters');
    
    % Filter parameters
    FilterOrder = 40;  % Filter order
    
    % Normalized frequency edges (relative to Nyquist frequency Fs/2)
    F3dB1 = (Fc - DeltaF) / (Fs/2);  % Lower 3-dB cutoff frequency
    F3dB2 = (Fc + DeltaF) / (Fs/2);  % Upper 3-dB cutoff frequency
    
    % Validate frequency values
    if F3dB1 < 0 || F3dB2 > 1
        error('Filter cutoff frequencies must be within the range [0, 1] normalized to Nyquist frequency.');
    end
    
    % Create the filter specification object
    RF_BPF_Spec = fdesign.bandpass('N,F3dB1,F3dB2', FilterOrder, F3dB1, F3dB2);
    
    % Design the filter
    RF_BPF = design(RF_BPF_Spec, 'butter');
    
    % Save the filter for future use
    save('Filters\RF_Band_Pass_Filter.mat', 'RF_BPF_Spec', 'RF_BPF');
    disp('Band-pass filter successfully created and saved.');
    
    % Visualize the filter's frequency response (optional)
    %fvtool(RF_BPF);
    
end
