function plotChannelSpectrum(channels)
    % Function to plot the spectrum of each audio channel.
    % Parameters:
    %   channels - Array of AudioFile objects (audio channels)
    
    % Define a set of colors to use for the plots
    colors = lines(length(channels));  % Generate 'length(channels)' distinct colors
    
    % Loop through each AudioFile object in the channels array
    for i = 1:length(channels)
        % Get the audio data and sampling frequency
        audioData = channels(i).AudioData;
        samplingFreq = channels(i).SamplingFrequency;

        % Perform FFT on the audio data
        n = length(audioData);          % Number of samples
        fftData = fft(audioData);       % Compute FFT
        fftData = fftData(1:n/2);      % Only keep the positive frequencies

        % Compute the frequency axis (in Hz)
        f = linspace(0, samplingFreq / 2, n / 2);

        % Compute the magnitude of the FFT
        magnitude = abs(fftData) / n;  % Normalize by number of samples
        
        % Create a new figure with two subplots
        figure;

        % Plot the linear magnitude spectrum
        subplot(2, 1, 1);  % 2 rows, 1 column, first plot
        plot(f, magnitude, 'Color', colors(i, :));  % Use a different color for each channel
        title(sprintf('Magnitude Spectrum of Channel %d', i));
        xlabel('Frequency (Hz)');
        ylabel('Magnitude');
        grid on;

        % Plot the log magnitude spectrum
        subplot(2, 1, 2);  % 2 rows, 1 column, second plot
        semilogx(f, 20 * log10(magnitude), 'Color', colors(i, :));  % Use the same color for the log plot
        title(sprintf('Log Magnitude Spectrum of Channel %d', i));
        xlabel('Frequency (Hz)');
        ylabel('Magnitude (dB)');
        grid on;

        % Display estimated bandwidth (where signal magnitude is above a threshold)
        threshold = max(magnitude) / 10;  % Set threshold to 10% of max magnitude
        bandWidth = sum(magnitude > threshold) * (f(2) - f(1));  % Bandwidth estimate

        fprintf('Estimated Bandwidth for Channel %d: %.2f Hz\n', i, bandWidth);
    end
end
