warning('off', 'MATLAB:print:ContentTypeImageSuggested')

%run = '20250513-133631'; % 1 m north
%run = '20250513-134500'; % 1 m east
runs = {
    {'20250513-135042', [27 8.5 1 0 0 0]', [27 8.5 1  0 0 20]'}, % 20 degrees heading
    {'20250513-141406', [27 8.5 1 0 0 0]', [27 8.5 1 20 0  0]'}, % 20 degrees roll
    {'20250513-133631', [27 8.5 1 0 0 0]', [28 8.5 1  0 0  0]'}, % 1 m north
    {'20250513-134500', [27 8.5 1 0 0 0]', [27 9.5 1  0 0  0]'} % 1 m east
}

for i = 1:numel(runs)

    run = runs{i}{1};
    startPos = runs{i}{2};
    refPos = runs{i}{3};

    dat = readh5(sprintf('./data/%s.h5', run), 60);
    filename = sprintf('./plots/pd-%s.pdf', run);
    
    cols20 = find(dat.t < 20);
    colsgt20 = find(dat.t >= 20);
    datRefPos = [repmat([0; 0; 0],1,numel(cols20)) repmat(refPos(1:3)-startPos(1:3), 1, numel(colsgt20))];
    datRefAng = [repmat([0; 0; 0],1,numel(cols20)) repmat(refPos(4:6), 1, numel(colsgt20))];

    fig = createFigure();
    subplot(3, 1, 1);
    plot(dat.t, dat.xi(1:3, :) - startPos(1:3)); hold on;
    set(gca,'ColorOrderIndex',1)
    plot(dat.t, datRefPos, '--'); hold on;
    xlabel('Time [s]', 'Interpreter', 'latex');
    ylabel('Position Deviation [m]', 'Interpreter', 'latex');
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
    plot(dat.t, rad2deg([roll pitch yaw]')); hold on;
    set(gca,'ColorOrderIndex',1)
    plot(dat.t, datRefAng, '--'); hold on;
    % desired angles
    %[roll_c, pitch_c, yaw_c] = quat2angle(dat.controller.xiDesired(4:7, :)', 'XYZ');
    %plot(dat.t, rad2deg([roll_c pitch_c yaw_c]), '--');
    xlabel('Time [s]', 'Interpreter', 'latex');
    ylabel('Euler Angles [deg]', 'Interpreter', 'latex');
    legend({'roll $\phi$', 'pitch $\theta$', 'yaw $\psi$'}, ...
    'Interpreter', 'latex', 'Location', 'east');

    grid on;
    
    subplot(3, 1, 3);
    plot(dat.t, rad2deg(dat.xi(8:11, :)));
    xlabel('Time [s]', 'Interpreter', 'latex');
    ylabel('Joint Angles [deg]', 'Interpreter', 'latex');
    legend({'$\theta_1$', '$\theta_2$', '$\theta_3$', '$\theta_4$'}, 'Interpreter', 'latex', 'Location', 'east');
    grid on;

    appendMode = true;
    if i == 1
        appendMode = false;
    end
    exportgraphics(fig, './plots/pd.pdf', 'ContentType', 'vector', 'Append', appendMode);

end

