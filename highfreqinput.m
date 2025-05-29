data = readh5('./data/20250513-165216.h5');
data = readh5('./data/20250513-154920.h5');

cols = find(data.t < 20);

figure
set(gcf, 'Position', [100, 100, 800, 2*200]);
subplot(2,1,1);
plot(data.t(cols), data.refs.joints(:,cols));
xlabel('Time [s]','Interpreter','latex');
ylabel('Joint motor reference [Nm]','Interpreter','latex');
legend({'$\theta_1$', '$\theta_2$', '$\theta_3$', '$\theta_4$'}, 'Interpreter', 'latex', 'Location', 'southeast');
grid on;
subplot(2,1,2);
plot(data.t(cols), data.refs.thrusters(:,cols));
xlabel('Time [s]','Interpreter','latex');
ylabel('Thruster reference [N]','Interpreter','latex');
legend({'$f_1$', '$f_2$', '$f_3$', '$f_4$','$f_5$', '$f_6$', '$f_7$', '$f_8$'}, 'Interpreter', 'latex', 'Location', 'southeast');
grid on;

