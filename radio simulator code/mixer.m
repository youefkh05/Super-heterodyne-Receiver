function Output_Audio_File = mixer(Input_Audio_File, Wc, WIF,Fs)
    % Function to simulate a mixer
    % Parameters:
    %   InputSignal - The input signal to be mixed
    %   omega_c     - Carrier frequency in radians/sec
    %   omega_IF    - Intermediate frequency (IF) in radians/sec
    %   Fs          - Sampling frequency in Hz
    %
    % Output:
    %   OutputSignal - The mixed output signal
    
    Output_Audio_File   =   Input_Audio_File;  %to have the same information
    
    % Time vector based on the input signal length and sampling frequency
    Length=length(Input_Audio_File.AudioData);
    Ts=1/Fs;    %Sample Time          
    t=[0:Ts:Length*Ts-Ts];   %Time vector
    
    % Generate the carrier signal with frequency (omega_c + omega_IF)
    CarrierSignal = cos(2 * pi * (Wc + WIF) * t)';
    
    % Perform the mixing (multiplication)
    OutputSignal = Input_Audio_File.AudioData .* CarrierSignal;
    
    % Update the mixed object's properties
    Output_Audio_File.AudioData = OutputSignal;
    Output_Audio_File.player = audioplayer(OutputSignal, Fs); % Update player
    
end
