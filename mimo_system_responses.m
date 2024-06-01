step_config = RespConfig;
step_config.Amplitude;

t = linspace(0,5,300);
u = [ones(length(t),1), zeros(length(t),1)];
[y, t, x] = lsim(sys_mimo, u, t);

impulse_config = RespConfig;
impulse_config.Amplitude = [5*pi/180, 0.5]; % 5 degrees elevator, "50%
% thrust increase

impulse(sys_mimo, impulse_config);
grid on
