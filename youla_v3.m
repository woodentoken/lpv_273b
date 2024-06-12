clearvars
load("saved_trim_states/0_alpha_trim.mat")
sys_as_tf=tf(ac.mimo_system);

s = sym('s');
%tfm = [-0.8747*s-3.036,8.105*s-0.6938;0.3095*s+0.003587,0.07073*s+0.3976];
tfm = [-2.664*s-5.298,24.68*s-1.211;0.54*s+0.01092,0.1234*s+1.211];
[N,del] = ss2tfm(ac.mimo_system.A, ac.mimo_system.B, ac.mimo_system.C, ac.mimo_system.D,1);
N2 = vpa(poly2sym(N),2);
del = vpa(poly2sym(del),2);

[U_l,U_r,Mp] = smithForm(tfm,s);
Mp = Mp/del;

%%
%clear vars
%syms('s');
s = tf('s');

%UL = [0 1;1 -20.93*s];
UL = [0 1;1 -20.93*s];
%UR = [-0.58 -0.028*s-0.1547; 2.52, 0.12*s+1.4e-3];
UR = [-0.1891 -0.009*s-0.0887; 0.8275, 0.0395*s+7.9965e-4];
del = s^2+0.2559*s+0.4687; % manual effort to change this for each system
Mpdel = [1 0; 0 (s^2+0.2559*s+0.4687)];
MP = Mpdel/del;

Y1 = 0.4687*10/(s+10);
Y2 = 0.4687*15/((s+15)*del);
MY = [Y1 0; 0 Y2];
MT = MP*MY;

Ty = inv(UL) * MT * UL;

Sy = eye(2)-Ty;
G_C = UR*inv(eye(2)-MT)*MY*UL;
Ly = sys_as_tf * G_C;
%%
% Y = U_r*MY*U_l
% G_C = U_r*inv(eye(2)-M_T)*MY*U_l;



% Gc11 = -(473387*(10000*s^2 + 1466*s + 4687))/(3508648*(5000*s^2 + 733*s)*(s^2 + (733*s)/5000 + 4687/10000));
% Gc12 = -(4687*((3535000*s)/128518487 + 19880000/128518487)*(10000*s^2 + 1466*s + 4687))/(20000*(5000*s^2 + 733*s)*(s^2 + (733*s)/5000 + 4687/10000));
% Gc21 = (14506265*(10000*s^2 + 1466*s + 4687))/(24560536*(5000*s^2 + 733*s)*(s^2 + (733*s)/5000 + 4687/10000));
% Gc22 = (4687*((15475000*s)/128518487 + 180000/128518487)*(10000*s^2 + 1466*s + 4687))/(20000*(5000*s^2 + 733*s)*(s^2 + (733*s)/5000 + 4687/10000));
% G_C = [Gc11 Gc12; Gc21 Gc22];



%T_y = (eye(2) + Ly)^(-1) * Ly; % Complementary sensitivity function
Y = G_C * (eye(2) + Ly)^(-1);

% % Plot singular values for Ty
% subplot(3, 1, 1);
% sigma(Ty);
% title('Singular Values of Ty');
% grid on;
% 
% % Plot singular values for Sy
% subplot(3, 1, 2);
% sigma(Sy);
% title('Singular Values of Sy');
% grid on;
% 
% % Plot singular values for Y
% subplot(3, 1, 3);
% sigma(Y);
% title('Singular Values of Y');
% grid on;
figure
sigma(Ty, 'g', Sy, 'r',Y,'y')
figure
step(Ty)

%% plotting
figure(1)
sigma(Ty,'g', Sy, 'r', Y, 'y', {10e-4, 10e4})
legend('Ty', 'Sy', 'Youla', 'Location', 'best')
grid on

ac.youla.Gc = minreal(G_C);
ac.youla.Ty = minreal(Ty);
ac.youla.Sy = minreal(Sy);
ac.youla.Y = minreal(Y);
save("saved_trim_states/0_alpha_trim.mat")
%step(Ty)