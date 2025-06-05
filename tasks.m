function plotLine(x, y, dist, color)
    lastIdx = 1;
    length = 0;
    for i = 2:numel(x)
        length = length + norm([x(i) - x(i-1), y(i) - y(i-1)]);
        if length >= dist
            %plot(x(lastIdx:i), y(lastIdx:i), 'Color', color); hold on;
            %plot(x(i-1), y(i-1), 'o', 'Color', color); hold on;
            %quiver(x(i-1), y(i-1), x(i) - x(i-1), y(i) - y(i-1), 0, 'Color', color, 'HeadSize', 0.5);
            %annotation('arrow', [x(i-1) x(i)], [y(i-1) y(i)]);
            tangent = [(x(i) - x(i-1)), (y(i) - y(i-1))];
            tangent = tangent / norm(tangent);
            orthogonal = [-tangent(2), tangent(1)];
            a = deg2rad(30);
            scale = 0.1;
            arr1 = - cos(a) * tangent + sin(a) * orthogonal;
            arr2 = - cos(a) * tangent - sin(a) * orthogonal;
            vals = [[x(i) y(i)] + scale * arr1; x(i) y(i); [x(i) y(i)] + scale * arr2 ];
            plot(vals(:, 1), vals(:, 2), 'Color', color); hold on;
            lastIdx = i;
            length = 0;
        end
    end
end

function y = lowpassSig(x, alpha)
    y = zeros(size(x));
    y(1) = x(1);
    for i = 2:numel(x)
        y(i) = alpha * x(i) + (1 - alpha) * y(i-1);
    end
end

warning('off', 'MATLAB:print:ContentTypeImageSuggested')
set(0, 'DefaultLineLineWidth', 1);

% -----------------------------------------------------------------------------
run = '20250519-141527'; % Smooth TPC stretch quaternion gains
dat = readh5(sprintf('./data/%s.h5', run), 60);
filename = sprintf('./plots/tasks.pdf', run);

figure
newFig(2);

nexttile
plot(dat.t, dat.tasks{1}.desired(1, :)); hold on;
xlabel('Time [s]', 'Interpreter', 'latex');
ylabel('North Position [m]', 'Interpreter', 'latex');
legend({'Tail Task'}, 'Interpreter', 'latex', 'Location', 'southeast');
grid on;

nexttile
plot(dat.tasks{1}.desired(1, :), dat.tasks{1}.desired(3, :)); hold on;
plot(dat.tasks{2}.desired(1, :), dat.tasks{2}.desired(3, :), 'o');
plotLine(dat.tasks{1}.desired(1, :), dat.tasks{1}.desired(3, :), 0.4, 'b'); hold on;

grid on;
set(gca, 'XDir','reverse')
set(gca, 'YDir','reverse')
xlabel('North [m]', 'Interpreter', 'latex');
ylabel('Depth [m]', 'Interpreter', 'latex');
legend({'Tail Task Trajectory', 'Head Task Setpoint'}, 'Interpreter', 'latex', 'Location', 'southeast');
xlim([6 14]);
axis equal;

exportgraphics(gcf, filename, 'ContentType', 'vector', 'Append', false);

% -----------------------------------------------------------------------------
run = '20250519-161629'; % Smooth TPC stretch quaternion gains
dat = readh5(sprintf('./data/%s.h5', run), 60);

newFig(2);

nexttile
plot(dat.t, dat.tasks{1}.desired(1, :),'b'); hold on;
plot(dat.t, dat.tasks{1}.desired(3, :),'b--'); hold on;
plot(dat.t, dat.tasks{2}.desired(1, :),'r'); hold on;
plot(dat.t, dat.tasks{2}.desired(3, :), 'r--'); hold on;
legend({'Tail Task North', 'Tail Task Depth', 'Head Task North', 'Head Task Depth'},...
'Interpreter', 'latex', 'Location', 'southeast');
xlabel('Time [s]', 'Interpreter', 'latex');
ylabel('[m]');
grid on;

nexttile
plot(dat.tasks{1}.desired(1, :), dat.tasks{1}.desired(3, :)); hold on;
plot(dat.tasks{2}.desired(1, :), dat.tasks{2}.desired(3, :));
plotLine(dat.tasks{1}.desired(1, :), dat.tasks{1}.desired(3, :), 0.4, 'b'); hold on;
plotLine(dat.tasks{2}.desired(1, :), dat.tasks{2}.desired(3, :), 0.4, 'r');
grid on;
set(gca, 'XDir','reverse')
set(gca, 'YDir','reverse')
xlabel('North [m]', 'Interpreter', 'latex');
ylabel('Depth [m]', 'Interpreter', 'latex');
legend({'Tail Task Trajectory', 'Head Task Trajectory'}, 'Interpreter', 'latex', 'Location', 'north');
axis equal;

exportgraphics(gcf, filename, 'ContentType', 'vector', 'Append', true);

% -----------------------------------------------------------------------------
run = '20250519-141527'; % Smooth TPC stretch quaternion gains
dat = readh5(sprintf('./data/%s.h5', run), 60);
figure
set(gcf, 'Position', [100, 100, 600, 2*150]);
plot(dat.tasks{1}.desired(1, :), dat.tasks{1}.desired(3, :), 'b--'); hold on;
plot(dat.tasks{2}.desired(1, :), dat.tasks{2}.desired(3, :), 'o'); hold on;
cols = find(dat.t >= 20);

plot(lowpassSig(dat.tasks{1}.value(1, cols), 0.1), lowpassSig(dat.tasks{1}.value(3, cols),0.1), 'b'); hold on;
plot(lowpassSig(dat.tasks{2}.value(1, cols), 0.1), lowpassSig(dat.tasks{2}.value(3, cols), 0.1), 'r'); hold on;
plot(dat.xiLowpass(1, cols), dat.xiLowpass(3, cols), 'k'); hold on;
%plot(dat.tasks{1}.value(1, :), dat.tasks{1}.value(3, :), 'b'); hold on;
%plot(dat.tasks{2}.value(1, :), dat.tasks{2}.value(3, :), 'r'); hold on;
plotLine(dat.tasks{1}.desired(1, :), dat.tasks{1}.desired(3, :), 0.4, 'b'); hold on;
plotLine(lowpassSig(dat.xiLowpass(1, cols),0.01), lowpassSig(dat.xiLowpass(3, cols),0.01), 0.4, 'k'); hold on;
%plotLine(lowpassSig(dat.tasks{2}.value(1, cols), 0.01), lowpassSig(dat.tasks{2}.value(3, cols), 0.01), 0.4, 'r'); hold on;
grid on;
set(gca, 'XDir','reverse')
set(gca, 'YDir','reverse')
xlabel('North [m]', 'Interpreter', 'latex');
ylabel('Depth [m]', 'Interpreter', 'latex');
legend({'Desired Tail Task Trajectory', 'Desired Head Task Setpoint', ...
    'Tail Task Trajectory', 'Head Task Trajectory', ...
    'Body Position'}, ...
    'Interpreter', 'latex', 'Location', 'northeast');
xlim([6 14]);
axis equal;

exportgraphics(gcf, filename, 'ContentType', 'vector', 'Append', true);

% -----------------------------------------------------------------------------
run = '20250519-161629'; % Smooth TPC stretch quaternion gains
dat = readh5(sprintf('./data/%s.h5', run), 60);

figure
set(gcf, 'Position', [100, 100, 600, 2*150]);
plot(dat.tasks{1}.desired(1, :), dat.tasks{1}.desired(3, :), 'b--'); hold on;
plot(dat.tasks{2}.desired(1, :), dat.tasks{2}.desired(3, :), 'r--');
plot(dat.tasks{1}.value(1, :), dat.tasks{1}.value(3, :), 'b'); hold on;
plot(dat.tasks{2}.value(1, :), dat.tasks{2}.value(3, :), 'r'); hold on;
plotLine(dat.tasks{1}.desired(1, :), dat.tasks{1}.desired(3, :), 0.4, 'b'); hold on;
plotLine(dat.tasks{2}.desired(1, :), dat.tasks{2}.desired(3, :), 0.4, 'r');
plot(dat.xiLowpass(1, :), dat.xiLowpass(3, :), 'k'); hold on;
%plot(dat.tasks{1}.desired(1, :), dat.tasks{1}.desired(3, :)); hold on;
%plot(dat.tasks{2}.desired(1, :), dat.tasks{2}.desired(3, :));
grid on;
set(gca, 'XDir','reverse')
set(gca, 'YDir','reverse')
xlabel('North [m]', 'Interpreter', 'latex');
ylabel('Depth [m]', 'Interpreter', 'latex');
legend({'Desired Tail Task Trajectory', 'Desired Head Task Trajectory', ...
    'Tail Task Trajectory', 'Head Task Trajectory'
    }, 'Interpreter', 'latex', 'Location', 'northeast');
axis equal;

exportgraphics(gcf, filename, 'ContentType', 'vector', 'Append', true);

