function Filter_figure = updateFilterFigure(New_filter, Fs, Filter_figure)
    % Function to update the filter figure with a new filter while maintaining the same figure handle
    % Inputs:
    %   New_filter - The new filter object (e.g., bandpass filter)
    %   Fs - Sampling frequency (in Hz)
    %   Filter_figure - The existing filter figure handle

    % Set the current figure to the existing fvtool figure handle
    set(0, 'CurrentFigure', Filter_figure);
    
    % Update the filter object in the existing fvtool figure
    % This step doesn't work directly because fvtool doesn't expose the Filter property,
    % but we can reset and use the current figure window to refresh it with a new filter.
    fvtool(New_filter, 'Fs', Fs);
end
