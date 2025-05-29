function data = readh5(filename)
    data = struct();
    data.t = h5read(filename, '/root/t');
    data.xi = h5read(filename, '/root/xi');
    data.zeta = h5read(filename, '/root/zeta');
    data.xiLowpass = h5read(filename, '/root/xiLowpass');
    data.zetaLowpass = h5read(filename, '/root/zetaLowpass');
    data.refs = struct();
    data.refs.joints = h5read(filename, '/root/refs/joints');
    data.refs.thrusters = h5read(filename, '/root/refs/thrusters');
end
