function mapped_frequency = map_radio_frequency(fr)
    % Maps the input frequency to the nearest value in a frequency array within a specified offset
    % Parameters:
    %   fr - Input frequency (Hz)
    % Returns:
    %   mapped_frequency - Nearest frequency in the array within the offset or original frequency

    % Define the frequency array and offset
    fr_array  = [100e3, 150e3, 200e3, 250e3, 300e3];  % Allowed frequencies (Hz)
    fr_offset = 10e3;                                % Allowed deviation (Hz)
    
    % Find the absolute differences between the input frequency and the array values
    differences = abs(fr_array - fr);
    
    % Find the minimum difference and its index
    [min_diff, idx] = min(differences);
    
    % Check if the minimum difference is within the allowable offset
    if min_diff <= fr_offset
        mapped_frequency = fr_array(idx);  % Map to the nearest frequency in the array
    else
        mapped_frequency = fr;  % Keep the input frequency unchanged
    end
end
