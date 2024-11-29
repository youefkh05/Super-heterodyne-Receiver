function plotFilter(Filter, Fs, titleStr)
    % Function to open fvtool and add a title annotation at the bottom.
    % Inputs:
    %   Filter - The filter object (e.g., bandpass filter)
    %   Fs - Sampling frequency (in Hz)
    %   titleStr - Title to be displayed below the filter plot

    % Open fvtool without title
    h = fvtool(Filter, 'Fs', Fs);

    % Get the position of the figure to place the annotation
    figPos = get(h, 'Position');  % Get the figure's position [left, bottom, width, height]

    % Add an annotation (title) at the bottom of the figure
    annotation('textbox', [0.35, 0.01, 0.3, 0.05], 'String', titleStr, ...
        'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
        'FontSize', 12, 'FontWeight', 'bold', 'EdgeColor', 'none');
end
