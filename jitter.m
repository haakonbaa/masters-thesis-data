data = readh5('./data/20250519-131915.h5');

cols = find(data.t > 70);

idx = 3;

figure
set(gcf, 'Position', [100, 100, 800, 200]);
plot(data.t(:,cols), rad2deg(data.xi(7+idx,cols)));
hold on;
xlabel('Time [s]','Interpreter','latex');
ylabel(strcat('$\theta_', sprintf('%i',idx),'$ [deg]'),'Interpreter','latex');
grid on
set(gca, 'TickLabelInterpreter', 'latex');
exportgraphics(gcf, './plots/jitter.pdf', 'ContentType', 'vector');

cols = find(data.t > 78 & data.t < 82);
figure
set(gcf, 'Position', [100, 100, 800, 200]);
plot(data.t(:,cols), rad2deg(data.xi(7+idx,cols)));
hold on;
plot(data.t(:,cols), rad2deg(data.xiLowpass(7+idx,cols)));
xlabel('Time [s]','Interpreter','latex');
ylabel(strcat('$\theta_', sprintf('%i',idx),'$ [deg]'),'Interpreter','latex');
legend({'Raw', 'Lowpass'}, 'Interpreter', 'latex', 'Location', 'northwest');
grid on
set(gca, 'TickLabelInterpreter', 'latex');
exportgraphics(gcf, './plots/jitter.pdf', 'ContentType', 'vector', 'Append', true);


%{

cols2 = 1 + find(diff(rad2deg(data.xi(7+idx,cols))) < 0.5);
plot(data.t(cols2), rad2deg(data.xi(7+idx,cols2)),'r');

jitterRemoved = interp1(data.t(cols2), data.xi(7+idx,cols2), data.t(cols), 'linear', 'extrap');
figure
plot(data.t(cols), rad2deg(data.xi(7+idx,cols) - jitterRemoved));

figure
t = sort(rad2deg(data.xi(7+idx,cols) - jitterRemoved))
t = t .* (t > 0);
plot(t);
plot(diff(sort(abs(diff(rad2deg(data.xi(7+idx,cols)))))))
%}
