function [sum_BW] = plotChannelSpectrum(channels, signalName, includeIndex)
    % Function to plot the spectrum of each audio channel.
    % Parameters:
    %   channels - Array of AudioFile objects (audio channels)
    %   signalName - Name to use in the titles (e.g., 'Audio Signal')
    %   includeIndex - Boolean flag to include the index in the titles
    
    % Default values for optional parameters
    if nargin < 2 || isempty(signalName)
        signalName = 'Channel'; % Default signal name
    end
    if nargin < 3 || isempty(includeIndex)
        includeIndex = true; % Default to include index
    end
    
    % Define a set of colors to use for the plots
    colors = lines(length(channels));  % Generate 'length(channels)' distinct colors
    sum_BW=0; % Initialize total bandwidth
    
    % Create a new figure for combined plots
    figure;
    
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
       
        % Generate titles based on input parameters
        if includeIndex == 1
            timeTitle = sprintf('Time Domain - %s %d', signalName, i);
            freqTitle = sprintf('Frequency Spectrum - %s %d', signalName, i);
        else
            timeTitle = sprintf('Time Domain - %s', signalName);
            freqTitle = sprintf('Frequency Spectrum - %s', signalName);
        end
        
        % Time-domain plot
        subplot(length(channels), 2, 2*i-1); % Left column for time-domain
        plot(t, audioData, 'Color', colors(i, :));
        title(timeTitle, 'FontSize', 12);
        xlabel('Time (s)', 'FontSize', 10);
        ylabel('Amplitude', 'FontSize', 10);
        grid on;
        
        % Frequency-domain plot
        subplot(length(channels), 2, 2*i); % Right column for frequency-domain
        plot(f, magnitudeCentered, 'Color', colors(i, :));
        title(freqTitle, 'FontSize', 12);
        xlabel('Frequency (Hz)', 'FontSize', 10);
        ylabel('Magnitude', 'FontSize', 10);
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
    
    %{
    % Add legends to subplots
    subplot(2, 1, 1);
    legend('show');
    subplot(2, 1, 2);
    legend('show');
    %}
    
end
