function bandwidth = getBandwidth(audioFile)
    % Function to calculate the bandwidth of an audio file
    % Parameters:
    %   audioFile - Path to the audio file
    % Returns:
    %   bandwidth - The estimated bandwidth of the audio signal in Hz
    
    % Step 1: Read the audio file
    audioData  = audioFile.AudioData;
    sampleFreq = audioFile.SamplingFrequency;
    colors = lines(length(audioFile));  % Generate 'length(channels)' distinct colors

    % Convert to mono if stereo
    if size(audioData, 2) > 1
        audioData = mean(audioData, 2);
    end
           
    % Step 2: Compute the Fourier Transform
    n = length(audioData);                 % Number of samples
    fftData = fft(audioData);              % Compute FFT
    magnitude = abs(fftData(1:floor(n/2)));% Magnitude spectrum (positive frequencies)
    f = linspace(0, sampleFreq/2, floor(n/2)); % Frequency vector

    % Step 3: Determine significant frequencies
    threshold = max(magnitude) * 0.1;      % 10% of max magnitude
    significantFreqs = f(magnitude > threshold);

    % Step 4: Calculate bandwidth
    if isempty(significantFreqs)
        bandwidth = 0; % No significant frequencies found
    else
        bandwidth = max(significantFreqs) - min(significantFreqs);
    end

    % Display results
    fprintf('Estimated Bandwidth: %.2f Hz\n', bandwidth);
    
    Ts = 1 / sampleFreq;                  % Sampling period
    t = (0:n-1) * Ts;                       % Time vector
    f = (-sampleFreq/2:sampleFreq/n:sampleFreq/2-sampleFreq/n); % Frequency vector
    
     % Perform FFT and shift for centered frequency-domain plot
     fftData = fft(audioData);
     fftShifted = fftshift(fftData);           % Shift zero frequency to the center
     magnitudeCentered = abs(fftShifted) / n; % Normalize magnitude
        

     % Plot the time-domain signal and centered frequency spectrum
     figure;

     % Time-domain plot
     subplot(2, 1, 1); % Top subplot
     plot(t, audioData, 'Color', colors(1, :));
     title(sprintf('Time Domain of Channel %d', 1));
     xlabel('Time (s)');
     ylabel('Amplitude');
     grid on;


     % Centered frequency-domain plot
     
     subplot(2, 1, 2); % Bottom subplot
     plot(f, magnitudeCentered, 'Color', colors(1, :));   
     title(sprintf('Centered Frequency Spectrum of Channel %d', 1));    
     xlabel('Frequency (Hz)');    
     ylabel('Magnitude');
     grid on;
        
end
