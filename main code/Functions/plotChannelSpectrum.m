function [sum_BW]   =   plotChannelSpectrum(channels)
    % Function to plot the spectrum of each audio channel.
    % Parameters:
    %   channels - Array of AudioFile objects (audio channels)
    
    % Define a set of colors to use for the plots
    colors = lines(length(channels));  % Generate 'length(channels)' distinct colors
    sum_BW=0; % Initialize total bandwidth
    
    % Get time and frequency vectors
    %N = length(channels(1).audioData);      % Number of samples
    
    
    % Loop through each AudioFile object in the channels array
    for i = 1:length(channels)
        % Get the audio data and sampling frequency
        audioData = channels(i).AudioData;
        samplingFreq = channels(i).SamplingFrequency;

        % Perform FFT on the audio data
        n = length(audioData);          % Number of samples
        Ts = 1 / samplingFreq;                  % Sampling period
        t = (0:n-1) * Ts;                       % Time vector in ms
        % Frequency vector (centered)
        f = linspace(-samplingFreq/2, samplingFreq/2, n);
            
        % Perform FFT and shift for centered frequency-domain plot
        fftData = fft(audioData);
        fftShifted = fftshift(fftData);           % Shift zero frequency to the center
        magnitudeCentered = abs(fftShifted) / n; % Normalize magnitude
        
        
         % Plot the time-domain signal and centered frequency spectrum
        figure;

        % Time-domain plot
        subplot(2, 1, 1); % Top subplot
        plot(t, audioData, 'Color', colors(i, :));
        title(sprintf('Time Domain of Channel %d', i), 'FontSize', 14);
        xlabel('Time (ms)', 'FontSize', 12);
        ylabel('Amplitude', 'FontSize', 12);
        grid on;

        % Centered frequency-domain plot
        subplot(2, 1, 2); % Bottom subplot
        plot(f, magnitudeCentered, 'Color', colors(i, :));
        title(sprintf('Centered Frequency Spectrum of Channel %d', i), 'FontSize', 14);
        xlabel('Frequency (kHz)', 'FontSize', 12);
        ylabel('Magnitude', 'FontSize', 12);
        grid on;

        % Bandwidth estimation
        threshold = max(magnitudeCentered) / 20;  % Set threshold at 5% of max magnitude
        significantFreqs = f(magnitudeCentered > threshold);
        if isempty(significantFreqs)
            bandwidth = 0; % No significant frequencies detected
        else
            bandwidth = max(significantFreqs) - min(significantFreqs); % Compute bandwidth
        end
        sum_BW = sum_BW + bandwidth;  % Accumulate total bandwidth

        % Display the estimated bandwidth
        fprintf('Estimated Bandwidth for Channel %d: %.2f kHz\n', i, bandwidth);
        
    end
    
end
