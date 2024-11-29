function plotReceiver(RF_channel, IF_channel, Bass_Band_channel)
    % Function to plot the time-domain and frequency-domain representation
    % of the RF, IF, and Baseband channels.
    %
    % Parameters:
    %   RF_channel - AudioFile object for the RF channel
    %   IF_channel - AudioFile object for the IF channel
    %   Bass_Band_channel - AudioFile object for the Baseband channel

    % Combine the channels into an array for processing
    channels = [RF_channel, IF_channel, Bass_Band_channel];
    channelNames = {'RF Channel', 'IF Channel', 'Baseband Channel'};
    
    % Define a set of colors for plots
    colors = lines(length(channels)); % Generate distinct colors
    
    % Create a new figure for plots
    figure;
    
    % Loop through each channel
    for i = 1:length(channels)
        % Get audio data and sampling frequency
        audioData = channels(i).AudioData;
        samplingFreq = channels(i).SamplingFrequency;

        % Time-domain parameters
        n = length(audioData);     % Number of samples
        Ts = 1 / samplingFreq;     % Sampling period
        t = (0:n-1) * Ts;          % Time vector
        
        % Frequency-domain parameters
        f = linspace(-samplingFreq/2, samplingFreq/2, n); % Frequency vector
        fftData = fft(audioData); % Perform FFT
        fftShifted = fftshift(fftData); % Shift zero frequency to center
        magnitudeCentered = abs(fftShifted) / n; % Normalize magnitude
        
        % Time-domain plot
        subplot(length(channels), 2, 2*i-1);
        plot(t, audioData, 'Color', colors(i, :));
        title(['Time Domain - ', channelNames{i}], 'FontSize', 12);
        xlabel('Time (s)', 'FontSize', 10);
        ylabel('Amplitude', 'FontSize', 10);
        grid on;
        
        % Frequency-domain plot
        subplot(length(channels), 2, 2*i);
        plot(f, magnitudeCentered, 'Color', colors(i, :));
        title(['Frequency Spectrum - ', channelNames{i}], 'FontSize', 12);
        xlabel('Frequency (Hz)', 'FontSize', 10);
        ylabel('Magnitude', 'FontSize', 10);
        grid on;
        
        % Bandwidth estimation
        threshold = max(magnitudeCentered) / 20; % Threshold at 5% of max magnitude
        significantFreqs = f(magnitudeCentered > threshold); % Find significant frequencies
        if isempty(significantFreqs)
            bandwidth = 0; % No significant frequencies
        else
            bandwidth = max(significantFreqs) - min(significantFreqs); % Bandwidth
        end
        
        % Display the estimated bandwidth
        fprintf('Estimated Bandwidth for %s: %.2f Hz\n', channelNames{i}, bandwidth);
    end
    
end
