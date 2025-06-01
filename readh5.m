function data = readh5(varargin)
    tlim = 10^6;
    if nargin >= 2
        tlim = varargin{2};
    end
    if nargin < 1
        error('Filename must be provided');
    else
        filename = varargin{1};
    end
    data = struct();
    data.t = h5read(filename, '/root/t');

    data.xi = h5read(filename, '/root/xi');
    data.zeta = h5read(filename, '/root/zeta');
    try
        data.xiLowpass = h5read(filename, '/root/xiLowpass');
        data.zetaLowpass = h5read(filename, '/root/zetaLowpass');
    catch
        data.xiLowpass = zeros(size(data.xi));
        data.zetaLowpass = zeros(size(data.zeta));
    end
    data.refs = struct();
    data.refs.joints = h5read(filename, '/root/refs/joints');
    data.refs.thrusters = h5read(filename, '/root/refs/thrusters');

    data.controller = struct();
    try
        data.controller.tau = h5read(filename, '/root/controller/tau');
        data.controller.xiDesired = h5read(filename, '/root/controller/xiDesired');
        data.controller.zetaDesired = h5read(filename, '/root/controller/zetaDesired');
    catch
        data.controller.tau = zeros(10, size(data.t, 2));
        data.controller.xiDesired = zeros(size(data.xi));
        data.controller.zetaDesired = zeros(size(data.zeta));
    end

    data.tasks = {};
    for i = 0:2
        data.tasks{i+1} = struct();
        data.tasks{i+1}.desired = h5read(filename, sprintf('/root/tasks/%i/desired', i));
        data.tasks{i+1}.value = h5read(filename, sprintf('/root/tasks/%i/value', i));
    end

    data = processStruct(data, find(data.t < tlim));
end

function s = processStruct(s, cols)
    fields = fieldnames(s);
    for i = 1:numel(fields)
        fname = fields{i};
        val = s.(fname);

        if isstruct(val)
            % Recurse if it's a nested struct
            s.(fname) = processStruct(val, cols);
        elseif isnumeric(val)
            % Apply your operation to the matrix
            s.(fname) = val(:, cols);
        elseif iscell(val)
            % If it's a cell array, process each cell
            newCell = cell(size(val));
            for j = 1:numel(val)
                if isnumeric(val{j})
                    newCell{j} = val{j}(:, cols);
                elseif isstruct(val{j})
                    % If it's a struct, recurse
                    newCell{j} = processStruct(val{j}, cols);
                else
                    newCell{j} = val{j}; % Keep non-numeric cells unchanged
                end
            end
            s.(fname) = newCell;
        end

    end
end
