function BPF = createBandPassFilter(Fc, Fs, DeltaF,FilterOrder)
    % createBandPassFilter - Designs a tunable band-pass filter
    %
    % Syntax:
    %   BPF = createBandPassFilter(Fc, Fs, DeltaF)
    %
    % Inputs:
    %   Fc - Carrier frequency (Hz)
    %   Fs - Sampling frequency (Hz)
    %   DeltaF - Bandwidth (Hz)
    %
    % Output:
    %   BPF - Designed band-pass filter object
    
    % Add the Functions and Filters folder to the MATLAB path temporarily
    addpath('Filters');
    
    
    % Normalized frequency edges (relative to Nyquist frequency Fs/2)
    F3dB1 = (Fc - DeltaF) / (Fs/2);  % Lower 3-dB cutoff frequency
    F3dB2 = (Fc + DeltaF) / (Fs/2);  % Upper 3-dB cutoff frequency
    
    % Validate frequency values
    if F3dB1 < 0 || F3dB2 > 1
        error('Filter cutoff frequencies must be within the range [0, 1] normalized to Nyquist frequency.');
    end
    
    % Create the filter specification object
    BPF_Spec = fdesign.bandpass('N,F3dB1,F3dB2', FilterOrder, F3dB1, F3dB2);
    
    % Design the filter
    BPF = design(BPF_Spec, 'butter');
    
    % Save the filter for future use
    %save('Filters\RF_Band_Pass_Filter.mat', 'BPF_Spec', 'BPF');
    disp('Band-pass filter successfully created and saved.');
    
    % Visualize the filter's frequency response (optional)
    %fvtool(BPF);
    
end
