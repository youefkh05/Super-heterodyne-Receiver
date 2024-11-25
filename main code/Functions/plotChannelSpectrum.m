function [sum_BW]   =   plotChannelSpectrum(channels)
    % Function to plot the spectrum of each audio channel.
    % Parameters:
    %   channels - Array of AudioFile objects (audio channels)
    
    % Define a set of colors to use for the plots
    colors = lines(length(channels));  % Generate 'length(channels)' distinct colors
    sum_BW=0;
    
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
        t = (0:n-1) * Ts;                       % Time vector
        f = (-samplingFreq/2:samplingFreq/n:samplingFreq/2-samplingFreq/n); % Frequency vector
            
        % Perform FFT and shift for centered frequency-domain plot
        fftData = fft(audioData);
        fftShifted = fftshift(fftData);           % Shift zero frequency to the center
        magnitudeCentered = abs(fftShifted) / n; % Normalize magnitude
        
         % Plot the time-domain signal and centered frequency spectrum
        figure;

        % Time-domain plot
        subplot(2, 1, 1); % Top subplot
        plot(t, audioData, 'Color', colors(i, :));
        title(sprintf('Time Domain of Channel %d', i));
        xlabel('Time (ms)');
        ylabel('Amplitude');
        grid on;

        % Centered frequency-domain plot
        subplot(2, 1, 2); % Bottom subplot
        plot(f, magnitudeCentered, 'Color', colors(i, :));
        title(sprintf('Centered Frequency Spectrum of Channel %d', i));
        xlabel('Frequency (kHz)');
        ylabel('Magnitude');
        grid on;


        % Bandwidth estimation (where signal magnitude is above a threshold)
        threshold = max(magnitudeCentered) / 20;  % Set threshold at 5% of max magnitude
        bandwidth = sum(magnitudeCentered > threshold) * (f(2) - f(1)); % Bandwidth estimation
        sum_BW = sum_BW + bandwidth;

        % Display the estimated bandwidth
        fprintf('Estimated Bandwidth for Channel %d: %.2f kHz\n', i, bandwidth);
        
    end
    
end
