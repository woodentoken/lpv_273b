clearvars;
clc;
close all;

%% uncertainty dynamics
W1 = makeweight(0.2,10,40);
Delta1 = ultidyn('Delta1',[1 1]);

W2 = makeweight(0.2,10,40);
Delta2 = ultidyn('Delta2',[1 1]);

clear real_G;
load("saved_trim_states/0_alpha_trim.mat")
real_G = ac.mimo_system
ac.trim.alpha_deg
ac.trim.airspeed
clear ac;
load("saved_trim_states/0_alpha_trim.mat")

G = ac.mimo_system*blkdiag(1+W1*Delta1, 1+W2*Delta2);
%G = real_G
ls_p = loopsens(G, ac.ltf_performant.Gc);
ls_r = loopsens(G, ac.ltf_robust.Gc);
ls_y = loopsens(G, ac.youla.Gc);
ls_pid = loopsens(G, ac.pid.Gc);
omega_range = {1e-3, 1e2};

%% plotting
tf = 50;

% figure(1)
% subplot(2,1,1)
% sigma(ls_p.To, 'g', ls_p.So, 'r', ls_p.CSo, 'b',  ac.ltf_performant.Gc*G, 'k', omega_range)
% grid on
% legend('Ty (performant)', 'Sy (performant)', 'Y (performant)', 'Open Loop (performant)', 'Location', 'south')
% title('Performant H\infty Characteristic Responses')
% hold on
% 
% 
% subplot(2,1,2)
% sigma(ls_r.To, 'g', ls_r.So, 'r', ls_r.CSo, 'b', ac.ltf_robust.Gc*G, 'k', omega_range)
% grid on
% legend('Ty (robust)', 'Sy (robust)', 'Y (robust)', 'Open Loop (robust)', 'Location', 'south')
% title('Robust H\infty Characteristic Responses')
% hold on
ls_p.To.InputName = {'Elevator', 'Thrust'};
ls_p.To.OutputName = {'Speed', 'Pitch Angle'};

ls_r.To.InputName = {'Elevator', 'Thrust'};
ls_r.To.OutputName = {'Speed', 'Pitch Angle'};

ls_y.To.InputName = {'Elevator', 'Thrust'};
ls_y.To.OutputName = {'Speed', 'Pitch Angle'};

ls_pid.To.InputName = {'Elevator', 'Thrust'};
ls_pid.To.OutputName = {'Speed', 'Pitch Angle'};

figure()
step(ls_y.To, 'g', ls_p.To, 'r', ls_r.To, 'b', ls_pid.To, 'k', [0 tf])
legend('Youla Parameterization', 'Performant H{\infty}', 'Robust H{\infty}',  'PID', 'Location', 'east')
title('Closed Loop Complementary Sensitivity Step Comparison')
grid on

figure()
step(ls_y.Y, 'g', ls_p.Y, 'r', ls_r.Y, 'b', ls_pid.Y, 'k', [0 tf])
legend('Youla Parameterization', 'Performant H{\infty}', 'Robust H{\infty}',  'PID', 'Location', 'east')
title('Closed Loop Complementary Sensitivity Step Comparison')
grid on

figure()
subplot(2,2,1)
wcsigmaplot(ls_p.To)
grid on
legend off
title('Performant H\infty worst case gain')

subplot(2,2,2)
wcsigmaplot(ls_r.To)
legend off
grid on
title('Robust H\infty worst case gain')

subplot(2,2,3)
wcsigmaplot(ls_y.To)
grid on
title('Youla worst case gain')

subplot(2,2,4)
wcsigmaplot(ls_pid.To)
legend off
grid on
title('PID worst case gain')

% figure()
% step(ls_p.To, 'r', ls_r.To, 'b', ls_pid.To, 'k', [0 tf])
% legend('Performant H{\infty}', 'Robust H{\infty}', 'PID', 'Location', 'east')
% title('Closed Loop Complementary Sensitivity Step Comparison')
% grid on

% figure()
% subplot(3,1,1)
% sigma(ls_p.So, 'r', ls_r.So, 'b', ls_y.So, 'g', ls_pid.So, 'k', omega_range)
% legend('Performant H{\infty}', 'Robust H{\infty}', 'Youla Parameterization', 'PID', 'Location', 'best')
% grid on
% title('Closed Loop Sensitivity Comparison, S{y}')
% 
% subplot(3,1,2)
% sigma(ls_p.To, 'r', ls_r.To, 'b', ls_y.To, 'g', ls_pid.To, 'k', omega_range)
% legend('Performant H{\infty}', 'Robust H{\infty}', 'Youla Parameterization', 'PID', 'Location', 'best')
% grid on
% title('Closed Loop Complementary Sensitivity Comparison, T{y}')
% 
% subplot(3,1,3)
% sigma(ls_p.CSo, 'r', ls_r.CSo, 'b', ls_y.CSo, 'g', ls_pid.CSo, 'k', omega_range)
% legend('Performant H{\infty}', 'Robust H{\infty}', 'Youla Parameterization', 'PID', 'Location', 'best')
% grid on
% title('Youla Comparison, Y')

%Ty_p = feedback(minreal(G*ac.ltf_performant.Gc))

%Ly_u_p = ac.ltf_performant.Gc*G;
%Ty_u_p = inv(eye(2)+Ly_u_p)*Ly_u_p;
%Sy_u_p = eye(2) - Ty_u_p;

% Ly_u_r = ac.ltf_robust.Gc*G;
% Ty_u_r = inv(eye(2)+Ly_u_r)*Ly_u_r;
% Sy_u_r = eye(2) - Ty_u_r;

%figure()
%sigma(Ty_u_p, 'r', Ty_u_r', 'b');
%sigma(Ty_p, 'r');

%figure()
%step(Ty_u_p, 'r', Ty_u_r', 'b');
%step(Ty_p, 'r');