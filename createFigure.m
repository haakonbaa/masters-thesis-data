function fig = createFigure()
    fig = figure;
    set(fig, 'PaperUnits', 'inches');
    set(fig, 'PaperSize', [8.27 11.69]); % A4 size in inches
    set(fig, 'PaperPosition', [0 0 8.27 11.69]); % Use full page
    set(fig, 'PaperOrientation', 'portrait'); % or 'landscape'
end

