%% Open loop
% these are the open loop responses of the system
% clearly, there is room for improvement, there is significant oscillation
% and coupling between the control inputs and the output channels
close all; clc;

alpha_condition = string(ac.alpha_trim*180/pi);

%% Impulse response
% configure the per channel impulse amounts (we don't want a 1 radian
% impulse (57.3 degrees!)
impulse_config = RespConfig;
% 5 degree elevator up, 20% thrust increase
impulse_config.Amplitude = [-5*pi/180, 0.2]; % 5 degrees elevator, "50% thrust increase
impulse_config.Delay = 0;

f1 = figure(1);
impulse(sys_mimo, impulse_config);
grid on
saveas(f1, 'plots/impulse_response_alpha=' + alpha_condition +'.png')

%% Step response (1 degree elevator down, 10% thrust increase)
step_config = RespConfig;
step_config.Amplitude = [1*pi/180, .1];

f2 = figure(2);
step(sys_mimo, step_config)
grid on
saveas(f2, 'plots/step_response_alpha=' + alpha_condition +'.png')

%% elevator only step response with aoa
f3 = figure(3);
elevator_deflection = 1; % degree(s) of elevator from trim state
t_sim = 100;

t = linspace(0,t_sim,10000);
u = [(elevator_deflection*pi/180)*ones(length(t),1), zeros(length(t),1)];

[y, t] = lsim(sys_mimo, u, t);

% add original trim airspeed for simplicity in interpretation
forward_speed = y(:,1)+ac.trim.airspeed;
normal_speed = y(:,2);

% aoa is basically normal speed / forward speed
aoa = (180/pi)*((y(:,2)./(y(:,1)+ac.trim.airspeed))) + ac.trim.alpha_deg;
pitch_rate = (180/pi)*(y(:,3));
pitch_angle= (180/pi)*(y(:,4));

% plot velocities on one plot
subplot(2,1,1)
plot(t, forward_speed, 'b-', 'Linewidth', 2);
hold on
grid on
plot(t, normal_speed, 'c-', 'Linewidth', 2);
yline(forward_speed(1), '-', 'original trim airspeed')
legend('forward speed', 'formal speed', 'location', 'southeast');
title('response to 1 degree elevator step input')
ylabel('velocity (m/s)')
ylim([-5 40])

% plot angles on another
subplot(2,1,2)
plot(t, aoa,'k-','Linewidth', 2);
hold on
grid on
plot(t, pitch_rate, 'm-', 'Linewidth', 2);
plot(t, pitch_angle, 'r-','Linewidth', 2);
yline(aoa(1), '-', 'original trim angle of attack')
ylabel('angle (deg) or angular rate (deg/s)')
legend('aoa', 'pitch rate', 'pitch', 'location', 'southeast');
xlabel('time (s)')
ylim([-30 30])
saveas(f3, 'plots/elevator_step_response_alpha=' + alpha_condition +'.png')

%% thrust only state response
f4 = figure(4);
thrust_amount = 0.1; % percentage of thrust increase from trim

t = linspace(0,t_sim,1000);
u = [zeros(length(t),1), thrust_amount*ones(length(t),1)];

[y, t] = lsim(sys_mimo, u, t);

% add original trim airspeed for simplicity in interpretation
forward_speed = y(:,1)+ac.trim.airspeed;
normal_speed = y(:,2);

% aoa is basically normal speed / forward speed
aoa = (180/pi)*((y(:,2)./(y(:,1)+ac.trim.airspeed))) + ac.trim.alpha_deg;
pitch_rate = (180/pi)*(y(:,3));
pitch_angle= (180/pi)*(y(:,4));

% plot velocities on one plot
subplot(2,1,1)
plot(t, forward_speed, 'b-', 'Linewidth', 2);
hold on
grid on
plot(t, normal_speed, 'c-', 'Linewidth', 2);
yline(forward_speed(1), '-', 'original trim airspeed')
legend('forward speed', 'normal speed', 'location', 'southeast');
ylabel('velocity (m/s)')
title('response to 10% thrust increase step input')
ylim([-5 40])

% plot angles on another
subplot(2,1,2)
plot(t, aoa,'k-', 'Linewidth', 2);
hold on
grid on
plot(t, pitch_rate, 'r-', 'Linewidth', 2);
plot(t, pitch_angle, 'm-','Linewidth', 2);
yline(aoa(1), '-', 'original trim angle of attack')
ylabel('angle (deg) or angular rate (deg/s)')
legend('aoa', 'pitch rate', 'pitch', 'location', 'southeast');
xlabel('time (s)')
ylim([-30 30])
saveas(f4, 'plots/thrust_step_response_alpha=' + alpha_condition +'.png')