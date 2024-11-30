function [Bass_Band_File, Bass_Band_Filter] = baseband_detection(Input_Audio_File, WIF, Fs)
    % baseband_detection_with_mixer - Detects the baseband signal using a mixer and LPF
    %
    % Syntax:
    %   [Bass_Band_File, Bass_Band_Filter] = baseband_detection_with_mixer(Input_Audio_File, Wc, WIF, Fs)
    %
    % Inputs:
    %   Input_Audio_File - The input audio file object containing audio data
    %   WIF              - Intermediate frequency (Hz)
    %   Fs               - Sampling frequency (Hz)
    %
    % Outputs:
    %   Bass_Band_File   - Audio file object with baseband signal
    %   Bass_Band_Filter - Low-pass filter used in the baseband detection

    % Step 1: Perform Mixing using the mixer function
    Mixed_Audio_File = mixer(Input_Audio_File, 0, WIF, Fs);

    % Step 2: Design the Low-Pass Filter
    FilterOrder = 40;          % Filter order (adjustable)
    Fc = WIF;                  % Cutoff frequency set to WIF
    Bass_Band_Filter = createLowPassFilter(Fc, Fs, FilterOrder);

    % Step 3: Apply the Low-Pass Filter
    FilteredSignal = filter(Bass_Band_Filter, Mixed_Audio_File.AudioData);

    % Step 4: Create the Output File with Baseband Signal
    Bass_Band_File = Input_Audio_File;  % Copy the input file structure
    Bass_Band_File.AudioData = FilteredSignal;
    Bass_Band_File.player = audioplayer(FilteredSignal, Fs); % Update player with baseband signal

    % Optional: Display a message
    disp('Baseband detection completed. The signal has been demodulated and filtered.');
end
