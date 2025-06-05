function newFig(num)
    tiledlayout(num, 1, 'Padding', 'compact', 'TileSpacing', 'compact');
    set(gcf, 'Position', [100, 100, 600, num*150]);
end
