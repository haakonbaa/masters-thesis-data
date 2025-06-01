function fig = createFigure()
    fig = figure;
    set(fig, 'PaperUnits', 'inches');
    set(fig, 'PaperSize', [8.27 11.69]); % A4 size in inches
    set(fig, 'PaperPosition', [0 0 8.27 11.69]); % Use full page
    set(fig, 'PaperOrientation', 'portrait'); % or 'landscape'
end

warning('off', 'MATLAB:print:ContentTypeImageSuggested')

run = '20250513-165216';

% DP
run = '20250513-135042'; % 20 degrees heading
run = '20250513-141406'; % 20 degrees roll
run = '20250513-133631'; % 1 m north
run = '20250513-134500'; % 1 m east
% Note: need to show offsets on the first two plots

% Low-pass v.s. no low-pass
run = '20250513-154920'; % Jittery TPC stretch
run = '20250519-135739'; % Smooth TPC stretch

% TPC stretch
run = '20250519-141527'; % Smooth TPC stretch quaternion gains
run = '20250519-144113'; % Smooth TPC stretch no compensation

% Set-based TPC bend
run = '20250519-161629'; % Smooth TPC bend tail highest pri 45 degrees joint limit with compensation
run = '20250519-161107'; % Smooth TPC bend tail highest pri 45 degrees joint limit no compensation

dat = readh5(sprintf('./data/%s.h5', run), 60);
filename = sprintf('./plots/%s.pdf', run);

% compensate for starting position.
%dat.xi(1:3,:) = dat.xi(1:3,:) - [27; 8.5; 1];


% Generalized Position --------------------------------------------------------
fig = createFigure();
subplot(3, 1, 1);
plot(dat.t, dat.xi(1:3, :));
xlabel('Time [s]', 'Interpreter', 'latex');
ylabel('Position [m]', 'Interpreter', 'latex');
legend({'$x^n$', '$y^n$', '$z^n$'}, 'Interpreter', 'latex', 'Location', 'east');
grid on;

subplot(3, 1, 2);
%{
plot(dat.t, dat.xi(4:7, :));
xlabel('Time [s]', 'Interpreter', 'latex');
ylabel('Quaternion', 'Interpreter', 'latex');
legend({'$q_1$', '$q_2$', '$q_3$', '$q_4$'}, 'Interpreter', 'latex', 'Location', 'east');
ylim([ min(min(dat.xi(4:7, :))) - 0.1, max(max(dat.xi(4:7, :))) + 0.1 ]);
%}
[roll, pitch, yaw] = quat2angle(dat.xi(4:7, :)', 'XYZ');
plot(dat.t, rad2deg([roll pitch yaw]));
xlabel('Time [s]', 'Interpreter', 'latex');
ylabel('Euler Angles [deg]', 'Interpreter', 'latex');
legend({'roll $\phi$', 'pitch $\theta$', 'yaw $\psi$'}, 'Interpreter', 'latex', 'Location', 'east');
grid on;

subplot(3, 1, 3);
plot(dat.t, rad2deg(dat.xi(8:11, :)));
xlabel('Time [s]', 'Interpreter', 'latex');
ylabel('Joint Angles [deg]', 'Interpreter', 'latex');
legend({'$\theta_1$', '$\theta_2$', '$\theta_3$', '$\theta_4$'}, 'Interpreter', 'latex', 'Location', 'east');
grid on;

exportgraphics(fig, filename, 'ContentType', 'vector', 'Append', false);

% Generalized Velocity ------------------------------------------------------
fig = createFigure();
subplot(3, 1, 1);
plot(dat.t, dat.zeta(1:3, :));
xlabel('Time [s]', 'Interpreter', 'latex');
ylabel('Velocity [m/s]', 'Interpreter', 'latex');
legend({'$v_x^n$', '$v_y^n$', '$v_z^n$'}, 'Interpreter', 'latex', 'Location', 'east');
grid on;

subplot(3, 1, 2);
plot(dat.t, rad2deg(dat.zeta(4:6, :)));
xlabel('Time [s]', 'Interpreter', 'latex');
ylabel('Angular Velocity [deg/s]', 'Interpreter', 'latex');
legend({'$\omega_1$', '$\omega_2$', '$\omega_3$'}, 'Interpreter', 'latex', 'Location', 'east');
grid on;

subplot(3, 1, 3);
plot(dat.t, rad2deg(dat.zeta(7:10, :)));
xlabel('Time [s]', 'Interpreter', 'latex');
ylabel('Joint Velocities [deg/s]', 'Interpreter', 'latex');
legend({'$\dot\theta_1$', '$\dot\theta_2$', '$\dot\theta_3$', '$\dot\theta_4$'}, 'Interpreter', 'latex', 'Location', 'east');
grid on;

exportgraphics(fig, filename, 'ContentType', 'vector', 'Append', true);

% Low-pass Filtered Generalized Position --------------------------------------------------------

fig = createFigure();
subplot(3, 1, 1);


plot(dat.t, dat.xiLowpass(1:3, :));
xlabel('Time [s]', 'Interpreter', 'latex');
ylabel('Position [m]', 'Interpreter', 'latex');
legend({'$x^n$', '$y^n$', '$z^n$'}, 'Interpreter', 'latex', 'Location', 'east');
grid on;

subplot(3, 1, 2);
%plot(dat.t, dat.xiLowpass(4:7, :));
[roll, pitch, yaw] = quat2angle(dat.xiLowpass(4:7, :)', 'XYZ');
plot(dat.t, rad2deg([roll pitch yaw]));
xlabel('Time [s]', 'Interpreter', 'latex');
ylabel('Euler Angles [deg]', 'Interpreter', 'latex');
%ylabel('Quaternion', 'Interpreter', 'latex');
%legend({'$q_1$', '$q_2$', '$q_3$', '$q_4$'}, 'Interpreter', 'latex', 'Location', 'east');
legend({'roll $\phi$', 'pitch $\theta$', 'yaw $\psi$'}, 'Interpreter', 'latex')%, 'Location', 'northwest');
grid on;

subplot(3, 1, 3);
plot(dat.t, rad2deg(dat.xiLowpass(8:11, :)));
xlabel('Time [s]', 'Interpreter', 'latex');
ylabel('Joint Angles [deg]', 'Interpreter', 'latex');
legend({'$\theta_1$', '$\theta_2$', '$\theta_3$', '$\theta_4$'}, 'Interpreter', 'latex', 'Location', 'east');
grid on;

exportgraphics(fig, filename, 'ContentType', 'vector', 'Append', true);

% Low-pass Filtered Generalized Velocity ---------------------------------------

fig = createFigure();
subplot(3, 1, 1);
plot(dat.t, dat.zetaLowpass(1:3, :));
xlabel('Time [s]', 'Interpreter', 'latex');
ylabel('Velocity [m/s]', 'Interpreter', 'latex');
legend({'$v_x^n$', '$v_y^n$', '$v_z^n$'}, 'Interpreter', 'latex', 'Location', 'east');
grid on;

subplot(3, 1, 2);
plot(dat.t, rad2deg(dat.zetaLowpass(4:6, :)));
xlabel('Time [s]', 'Interpreter', 'latex');
ylabel('Angular Velocity [deg/s]', 'Interpreter', 'latex');
legend({'$\omega_1$', '$\omega_2$', '$\omega_3$'}, 'Interpreter', 'latex', 'Location', 'east');
grid on;

subplot(3, 1, 3);
plot(dat.t, rad2deg(dat.zetaLowpass(7:10, :)));
xlabel('Time [s]', 'Interpreter', 'latex');
ylabel('Joint Velocities [deg/s]', 'Interpreter', 'latex');
legend({'$\dot\theta_1$', '$\dot\theta_2$', '$\dot\theta_3$', '$\dot\theta_4$'}, 'Interpreter', 'latex', 'Location', 'east');
grid on;

exportgraphics(fig, filename, 'ContentType', 'vector', 'Append', true);

% Controller thruster / joint motor references --------------------------------

fig = createFigure();
subplot(3, 1, 1);
plot(dat.t, dat.refs.thrusters(1:4, :));
xlabel('Time [s]', 'Interpreter', 'latex');
ylabel('Thruster Ref [N]', 'Interpreter', 'latex');
legend({'$f_1$', '$f_2$', '$f_3$', '$f_4$'}, 'Interpreter', 'latex', 'Location', 'east');
grid on;

subplot(3, 1, 2);
plot(dat.t, dat.refs.thrusters(5:8, :));
xlabel('Time [s]', 'Interpreter', 'latex');
ylabel('Thruster Ref [N]', 'Interpreter', 'latex');
legend({'$f_5$', '$f_6$', '$f_7$', '$f_8$'}, 'Interpreter', 'latex', 'Location', 'east');
grid on;

subplot(3, 1, 3);
plot(dat.t, dat.refs.joints(1:4, :));
xlabel('Time [s]', 'Interpreter', 'latex');
ylabel('Joint Motor Ref [Nm]', 'Interpreter', 'latex');
legend({'$\tau_1$', '$\tau_2$', '$\tau_3$', '$\tau_4$'}, 'Interpreter', 'latex', 'Location', 'east');
grid on;

exportgraphics(fig, filename, 'ContentType', 'vector', 'Append', true);

% Controller desired forces and torques
fig = createFigure();
subplot(3, 1, 1);
plot(dat.t, dat.controller.tau(1:3, :));
xlabel('Time [s]', 'Interpreter', 'latex');
ylabel('Body Force [N]', 'Interpreter', 'latex');
legend({'$f_x^b$', '$f_y^b$', '$f_z^b$'}, 'Interpreter', 'latex', 'Location', 'east');
grid on;

subplot(3, 1, 2);
plot(dat.t, dat.controller.tau(4:6, :));
xlabel('Time [s]', 'Interpreter', 'latex');
ylabel('Body Torque [deg/s]', 'Interpreter', 'latex');
legend({'$\tau_x^b$', '$\tau_y^b$', '$\tau_z^b$'}, 'Interpreter', 'latex', 'Location', 'east');
grid on;

subplot(3, 1, 3);
plot(dat.t, dat.controller.tau(7:10, :));
xlabel('Time [s]', 'Interpreter', 'latex');
ylabel('Joint Torque [Nm]', 'Interpreter', 'latex');
legend({'$\tau_1$', '$\tau_2$', '$\tau_3$', '$\tau_4$'}, 'Interpreter', 'latex', 'Location', 'east');
grid on;

exportgraphics(fig, filename, 'ContentType', 'vector', 'Append', true);

for i = 1:3
    task = dat.tasks{i};
    fig = createFigure();
    subplot(2, 1, 1);
    plot(dat.t, task.desired, '--'); hold on;
    xlabel('Time [s]', 'Interpreter', 'latex');
    ylabel('Desired Task Value', 'Interpreter', 'latex');
    grid on;

    plot(dat.t, task.value);
    xlabel('Time [s]', 'Interpreter', 'latex');
    ylabel('Task Value', 'Interpreter', 'latex');
    legend({'$\sigma_{1,d}$', '$\sigma_{2,d}$', '$\sigma_{3,d}$', ...
        '$\sigma_{1}$', '$\sigma_{2}$', '$\sigma_{3}$'}, ...
        'Interpreter', 'latex', 'Location', 'east');
    grid on;

    subplot(2, 1, 2);
    plot(dat.t, vecnorm(task.desired - task.value));
    xlabel('Time [s]', 'Interpreter', 'latex');
    if i == 1 || i == 2
        ylabel('Task Error [m]', 'Interpreter', 'latex');
    else
        ylabel('Task Error', 'Interpreter', 'latex');
    end
    grid on;

    exportgraphics(fig, filename, 'ContentType', 'vector', 'Append', true);
end

% Controller time -------------------------------------------------------------

fig = createFigure();
histogram(diff(dat.t), 'Normalization', 'percentage');
xlabel('Control Loop Time [s]', 'Interpreter', 'latex');
ylabel('Percentage', 'Interpreter', 'latex');
grid on;
exportgraphics(fig, filename, 'ContentType', 'vector', 'Append', true);


% Tasks desired vs actual
% task error
%exportgraphics(fig, filename, 'ContentType', 'vector', 'Append', true);
