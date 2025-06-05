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
% -----------------------------------------------------------------------------
run = '20250519-141527'; % Smooth TPC stretch quaternion gains


dat = readh5(sprintf('./data/%s.h5', run), 60);
filename = sprintf('./plots/%s.pdf', run);
colors = rgb2hex(orderedcolors("gem"))
offset = [0; 0; 0];
if run == '20250519-141527'
    offset = [11; 36; 10];
elseif run == '20250519-161629'
    offset = [11; 36; 10];
elseif run == '20250519-161107'
    offset = [11; 36; 10];
end


% compensate for starting position.
%dat.xi(1:3,:) = dat.xi(1:3,:) - [27; 8.5; 1];


% Generalized Position --------------------------------------------------------
newFig(3);
nexttile;
plot(dat.t, dat.xi(1:3, :) - offset); hold on;
set(gca,'xticklabel',[])
ylabel('Position [m]', 'Interpreter', 'latex');
legend({'$x^n$', '$y^n$', '$z^n$'}, 'Interpreter', 'latex', 'Location', 'east');
grid on;

nexttile;
[roll, pitch, yaw] = quat2angle(dat.xi(4:7, :)', 'XYZ');
plot(dat.t, rad2deg([roll pitch yaw])); hold on;
set(gca,'xticklabel',[])
ylabel('Euler Angles [deg]', 'Interpreter', 'latex');
legend({'roll $\phi$', 'pitch $\theta$', 'yaw $\psi$'}, 'Interpreter', 'latex', 'Location', 'east');
grid on;

nexttile;
plot(dat.t, rad2deg(dat.xi(8:11, :)));
xlabel('Time [s]', 'Interpreter', 'latex');
ylabel('Joint Angles [deg]', 'Interpreter', 'latex');
legend({'$\theta_1$', '$\theta_2$', '$\theta_3$', '$\theta_4$'}, 'Interpreter', 'latex', 'Location', 'east');
grid on;

exportgraphics(gcf, filename, 'ContentType', 'vector', 'Append', false);

% Generalized Velocity ------------------------------------------------------
newFig(3)

nexttile;
plot(dat.t, dat.zeta(1:3, :)); hold on;
set(gca,'xticklabel',[])
ylabel('Velocity [m/s]', 'Interpreter', 'latex');
legend({'$v_x^n$', '$v_y^n$', '$v_z^n$'}, 'Interpreter', 'latex', 'Location', 'east');
grid on;

nexttile;
plot(dat.t, rad2deg(dat.zeta(4:6, :)));
set(gca,'xticklabel',[])
ylabel('Angular Velocity [deg/s]', 'Interpreter', 'latex');
legend({'$\omega_1$', '$\omega_2$', '$\omega_3$'}, 'Interpreter', 'latex', 'Location', 'east');
grid on;

nexttile;
plot(dat.t, rad2deg(dat.zeta(7:10, :)));
xlabel('Time [s]', 'Interpreter', 'latex');
ylabel('Joint Velocities [deg/s]', 'Interpreter', 'latex');
legend({'$\dot\theta_1$', '$\dot\theta_2$', '$\dot\theta_3$', '$\dot\theta_4$'}, 'Interpreter', 'latex', 'Location', 'east');
grid on;

exportgraphics(gcf, filename, 'ContentType', 'vector', 'Append', true);

% Low-pass Filtered Generalized Position --------------------------------------------------------

newFig(3);

nexttile;
plot(dat.t, dat.xiLowpass(1:3, :) - offset); hold on;
set(gca,'xticklabel',[])
ylabel('Position [m]', 'Interpreter', 'latex');
legend({'$x^n$', '$y^n$', '$z^n$'}, 'Interpreter', 'latex', 'Location', 'east');
grid on;

nexttile;
[roll, pitch, yaw] = quat2angle(dat.xiLowpass(4:7, :)', 'XYZ');
plot(dat.t, rad2deg([roll pitch yaw]));
set(gca,'xticklabel',[])
ylabel('Euler Angles [deg]', 'Interpreter', 'latex');
legend({'roll $\phi$', 'pitch $\theta$', 'yaw $\psi$'}, 'Interpreter', 'latex')%, 'Location', 'northwest');
grid on;

nexttile;
plot(dat.t, rad2deg(dat.xiLowpass(8:11, :)));
xlabel('Time [s]', 'Interpreter', 'latex');
ylabel('Joint Angles [deg]', 'Interpreter', 'latex');
legend({'$\theta_1$', '$\theta_2$', '$\theta_3$', '$\theta_4$'}, 'Interpreter', 'latex', 'Location', 'east');
grid on;

exportgraphics(gcf, filename, 'ContentType', 'vector', 'Append', true);

% Low-pass Filtered Generalized Velocity ---------------------------------------

newFig(3);
nexttile;
plot(dat.t, dat.zetaLowpass(1:3, :));
set(gca,'xticklabel',[])
ylabel('Velocity [m/s]', 'Interpreter', 'latex');
legend({'$v_x^n$', '$v_y^n$', '$v_z^n$'}, 'Interpreter', 'latex', 'Location', 'east');
grid on;

nexttile;
plot(dat.t, rad2deg(dat.zetaLowpass(4:6, :)));
set(gca,'xticklabel',[])
ylabel('Angular Velocity [deg/s]', 'Interpreter', 'latex');
legend({'$\omega_1$', '$\omega_2$', '$\omega_3$'}, 'Interpreter', 'latex', 'Location', 'east');
grid on;

nexttile;
plot(dat.t, rad2deg(dat.zetaLowpass(7:10, :)));
xlabel('Time [s]', 'Interpreter', 'latex');
ylabel('Joint Velocities [deg/s]', 'Interpreter', 'latex');
legend({'$\dot\theta_1$', '$\dot\theta_2$', '$\dot\theta_3$', '$\dot\theta_4$'}, 'Interpreter', 'latex', 'Location', 'east');
grid on;

exportgraphics(gcf, filename, 'ContentType', 'vector', 'Append', true);

% Controller thruster / joint motor references --------------------------------

newFig(3);

nexttile;
plot(dat.t, dat.refs.thrusters(1:4, :));
set(gca,'xticklabel',[])
ylabel('Thruster Ref [N]', 'Interpreter', 'latex');
legend({'$f_1$', '$f_2$', '$f_3$', '$f_4$'}, 'Interpreter', 'latex', 'Location', 'east');
grid on;

nexttile;
plot(dat.t, dat.refs.thrusters(5:8, :));
set(gca,'xticklabel',[])
ylabel('Thruster Ref [N]', 'Interpreter', 'latex');
legend({'$f_5$', '$f_6$', '$f_7$', '$f_8$'}, 'Interpreter', 'latex', 'Location', 'east');
grid on;

nexttile;
plot(dat.t, dat.refs.joints(1:4, :));
xlabel('Time [s]', 'Interpreter', 'latex');
ylabel('Joint Motor Ref [Nm]', 'Interpreter', 'latex');
legend({'$\tau_1$', '$\tau_2$', '$\tau_3$', '$\tau_4$'}, 'Interpreter', 'latex', 'Location', 'east');
grid on;

exportgraphics(gcf, filename, 'ContentType', 'vector', 'Append', true);

% Controller desired forces and torques ---------------------------------------
newFig(3);

nexttile;
plot(dat.t, dat.controller.tau(1:3, :));
set(gca,'xticklabel',[])
ylabel('Body Force [N]', 'Interpreter', 'latex');
legend({'$f_x^b$', '$f_y^b$', '$f_z^b$'}, 'Interpreter', 'latex', 'Location', 'east');
grid on;

nexttile;
plot(dat.t, dat.controller.tau(4:6, :));
set(gca,'xticklabel',[])
ylabel('Body Torque [deg/s]', 'Interpreter', 'latex');
legend({'$\tau_x^b$', '$\tau_y^b$', '$\tau_z^b$'}, 'Interpreter', 'latex', 'Location', 'east');
grid on;

nexttile;
plot(dat.t, dat.controller.tau(7:10, :));
xlabel('Time [s]', 'Interpreter', 'latex');
ylabel('Joint Torque [Nm]', 'Interpreter', 'latex');
legend({'$\tau_1$', '$\tau_2$', '$\tau_3$', '$\tau_4$'}, 'Interpreter', 'latex', 'Location', 'east');
grid on;

exportgraphics(gcf, filename, 'ContentType', 'vector', 'Append', true);

% Task Trajectories -----------------------------------------------------------

for i = 1:3
    task = dat.tasks{i};

    newFig(2);

    nexttile;
    plot(dat.t, task.desired, '--'); hold on;
    grid on;
    plot(dat.t, task.value);
    set(gca,'xticklabel',[])
    ylabel('Task Value', 'Interpreter', 'latex');
    legend({'$\sigma_{1,d}$', '$\sigma_{2,d}$', '$\sigma_{3,d}$', ...
        '$\sigma_{1}$', '$\sigma_{2}$', '$\sigma_{3}$'}, ...
        'Interpreter', 'latex', 'Location', 'east');
    grid on;

    nexttile;
    plot(dat.t, vecnorm(task.desired - task.value));
    xlabel('Time [s]', 'Interpreter', 'latex');
    if i == 1 || i == 2
        ylabel('Task Error [m]', 'Interpreter', 'latex');
    else
        ylabel('Task Error', 'Interpreter', 'latex');
    end
    grid on;

    exportgraphics(gcf, filename, 'ContentType', 'vector', 'Append', true);
end

% Controller time -------------------------------------------------------------

newFig(1);

nexttile;
histogram(diff(dat.t), 'Normalization', 'percentage');
xlabel('Control Loop Time [s]', 'Interpreter', 'latex');
ylabel('Percentage', 'Interpreter', 'latex');
grid on;

exportgraphics(gcf, filename, 'ContentType', 'vector', 'Append', true);

% Controller Tracking ---------------------------------------------------------

newFig(3);

nexttile;
plot(dat.t, dat.xi(1, :) - offset(1), 'Color', colors(1)); hold on;
plot(dat.t, dat.xi(2, :) - offset(2), 'Color', colors(2)); hold on;
plot(dat.t, dat.xi(3, :) - offset(3), 'Color', colors(3)); hold on;
plot(dat.t, dat.controller.xiDesired(1, :) - offset(1), '--', 'Color', colors(1)); hold on;
plot(dat.t, dat.controller.xiDesired(2, :) - offset(2), '--', 'Color', colors(2)); hold on;
plot(dat.t, dat.controller.xiDesired(3, :) - offset(3), '--', 'Color', colors(3)); hold on;
set(gca,'xticklabel',[])
ylabel('Position [m]', 'Interpreter', 'latex');
legend({'$x^n$', '$y^n$', '$z^n$'}, 'Interpreter', 'latex', 'Location', 'east');
grid on;

nexttile;
[roll, pitch, yaw] = quat2angle(dat.xi(4:7, :)', 'XYZ');
plot(dat.t, rad2deg(roll), 'Color', colors(1)); hold on;
plot(dat.t, rad2deg(pitch), 'Color', colors(2)); hold on;
plot(dat.t, rad2deg(yaw), 'Color', colors(3)); hold on;

[roll, pitch, yaw] = quat2angle(dat.controller.xiDesired(4:7, :)', 'XYZ');
plot(dat.t, rad2deg(roll),'--', 'Color', colors(1)); hold on;
plot(dat.t, rad2deg(pitch),'--', 'Color', colors(2)); hold on;
plot(dat.t, rad2deg(yaw),'--', 'Color', colors(3)); hold on;

set(gca,'xticklabel',[])
ylabel('Euler Angles [deg]', 'Interpreter', 'latex');
legend({'roll $\phi$', 'pitch $\theta$', 'yaw $\psi$'}, 'Interpreter', 'latex', 'Location', 'east');
grid on;

nexttile;
plot(dat.t, rad2deg(dat.xi(8:11, :))); hold on;
plot(dat.t, rad2deg(dat.controller.xiDesired(8, :)),'--', 'Color', colors(1)); hold on;
plot(dat.t, rad2deg(dat.controller.xiDesired(9, :)),'--', 'Color', colors(2)); hold on;
plot(dat.t, rad2deg(dat.controller.xiDesired(10, :)),'--', 'Color', colors(3)); hold on;
plot(dat.t, rad2deg(dat.controller.xiDesired(11, :)),'--', 'Color', colors(4)); hold on;
xlabel('Time [s]', 'Interpreter', 'latex');
ylabel('Joint Angles [deg]', 'Interpreter', 'latex');
legend({'$\theta_1$', '$\theta_2$', '$\theta_3$', '$\theta_4$'}, 'Interpreter', 'latex', 'Location', 'east');
grid on;

exportgraphics(gcf, filename, 'ContentType', 'vector', 'Append', true);
