data = readh5('./data/20250519-131915.h5');

cols = find(data.t > 70);

figure
set(gcf, 'Position', [100, 100, 800, 200]);
plot(data.t(:,cols), rad2deg(data.xi(7+3,cols)));
xlabel('Time [s]','Interpreter','latex');
ylabel('$\theta_3$ [deg]','Interpreter','latex');
grid on
set(gca, 'TickLabelInterpreter', 'latex');
exportgraphics(gcf, './plots/jitter.pdf', 'ContentType', 'vector');
