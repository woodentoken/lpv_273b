%% PID
load("saved_trim_states/0_alpha_trim.mat")
Gp = tf(sys_mimo_2x2);
s = tf('s');
Decop = [1 0.1; 0.1 1];

PI_upper =-0.313862 -0.121139/s -0.156870*3.309/(1+3.309/s);
PI_lower = 1.77717 +2.976602/s +0.025806*6.327749/(1+6.327749/s);
Gc = [PI_upper 0;
      0 PI_lower]*Decop;

% new_plant = Gp*Gc;
% PI_upper = -0.313862 -0.121139/s -0.156870*3.309/(1+3.309/s);
% PI_lower = 1.77717 +2.976602/s +0.025806*6.327749/(1+6.327749/s);
% PI = [PI_upper 0; 0 PI_lower];
% Gc = PI*Decop;
closed_final = feedback(Gp*Gc, eye(2));
closed_final.InputName = {'Elevator', 'Thrust'};
closed_final.OutputName = {'Speed', 'Pitch Angle'};
Ly = Gp*Gc;
Lu = Gc*Gp;
Ty = inv(eye(2)+Ly)*Ly;
Sy = eye(2)-Ty;
Y = inv(eye(2)+Lu)*Gc;

ac.pid.Gc = Gc;
ac.pid.Ty = Ty;
ac.pid.Ly = Ly;
ac.pid.Sy = Sy;
ac.pid.Y = Y;


save("saved_trim_states/0_alpha_trim.mat")