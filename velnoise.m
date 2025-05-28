data = readh5('./data/20250519-161629.h5');
data = readh5('./data/20250519-131915.h5');

function plotZeta(t, zeta, append)
    figure
    set(gcf, 'Position', [100, 100, 800, 3*200]);
    subplot(3,1,1);
    plot(t, zeta(1:3,:)); grid on;
    legend({'$v_x$', '$v_y$', '$v_z$'}, 'Interpreter', 'latex', 'Location', 'southeast');
    xlabel('Time [s]','Interpreter','latex');
    ylabel('Velocity [m/s]','Interpreter','latex');
    
    subplot(3,1,2);
    plot(t, rad2deg(zeta(4:6,:))); grid on;
    xlabel('Time [s]','Interpreter','latex');
    ylabel('Angular velocity [deg/s]','Interpreter','latex');
    legend({'$\omega_x$', '$\omega_y$', '$\omega_z$'}, 'Interpreter', 'latex', 'Location', 'southeast');
    
    subplot(3,1,3);
    plot(t, rad2deg(zeta(7:end,:))); grid on;
    xlabel('Time [s]','Interpreter','latex');
    ylabel('Angular velocity [deg/s]','Interpreter','latex');
    legend({'$\dot{\theta}_1$', '$\dot{\theta}_2$', '$\dot{\theta}_3$', '$\dot{\theta}_4$'}, 'Interpreter','latex', 'Location', 'southeast');
    exportgraphics(gcf, './plots/velnoise.pdf', 'ContentType', 'vector', 'Append', append);
end

cols = find(data.t < 10);
plotZeta(data.t(:,cols), data.zeta(:,cols), false);
plotZeta(data.t(:,cols), data.zetaLowpass(:,cols), true);

figure
set(gcf, 'Position', [100, 100, 800, 200]);
hold on;
lw = 1.5;
plot(data.t(:,cols), 100 * data.zetaLowpass(3,cols),'-', 'LineWidth', lw, 'color', 0.6*[1 0 1]); grid on;
plot(data.t(:,cols), 100 * data.zeta(3,cols),'color',[1 0 1]); grid on;
plot(data.t(:,cols), rad2deg(data.zetaLowpass(4,cols)),'-', 'LineWidth', lw, 'color', 0.6*[1 0 0]); grid on;
plot(data.t(:,cols), rad2deg(data.zeta(4,cols)),'r'); grid on;
plot(data.t(:,cols), rad2deg(data.zetaLowpass(6+1,cols)),'-', 'LineWidth', lw, 'color', 0.6*[0 1 0]); grid on;
plot(data.t(:,cols), rad2deg(data.zeta(6+1,cols)),'g'); grid on;
legend({'$v_z$ lowpass [cm/s]', '$v_z$ [cm/s]', ...
        '$\omega_x$ lowpass [deg/s]', '$\omega_x$ [deg/s]', ...
        '$\dot{\theta}_1$ lowpass [deg/s]', '$\dot{\theta}_1$ [deg/s]'
        }, ...
       'Interpreter', 'latex', 'Location', 'northeast');
ylim([-5 5]);
exportgraphics(gcf, './plots/velnoise.pdf', 'ContentType', 'vector', 'Append', true);

