clearvars
load("saved_trim_states/0_alpha_trim.mat")
sys_as_tf=tf(ac.mimo_system);

s = sym('s');
tfm = [-0.8747*s-3.0357,8.1051*s-0.6938;0.3095*s+0.0036,0.0707*s+0.3976];

[N,del] = ss2tfm(ac.mimo_system.A, ac.mimo_system.B, ac.mimo_system.C, ac.mimo_system.D,1);
N2 = vpa(poly2sym(N),2);
del = vpa(poly2sym(del),2);

[U_l,U_r,Mp] = smithForm(tfm,s);
Mp = Mp/del;

%%
%clear vars
syms('s');
%s = tf('s');

UL = [0 1;1 -21*s];
UR = [-0.58 -0.028*s-0.15; 2.5 0.12*s+1.4e-3];
del = s^2+0.15*s+0.47; % manual effort to change this for each system
Mpdel = [1 0; 0 (s^2+0.15*s+0.47)];
MP = Mpdel/del;

Y1 = 0.47;
Y2 = 0.47/del;
MY = [Y1 0; 0 Y2];
MT = MP*MY;

Ty = inv(UL) * MT * UL;

S_y = 1-Ty;
G_C = UR*inv(eye(2)-MT)*MY*UL;


s = tf('s');
Ty = [0.47/(s^2+0.15*s+0.47) 0; 0 0.47/(s^2+0.15*s+0.47)];
Sy = eye(2) - Ty;


%%
% Y = U_r*MY*U_l
% G_C = U_r*inv(eye(2)-M_T)*MY*U_l;



% Gc11 = -(473387*(10000*s^2 + 1466*s + 4687))/(3508648*(5000*s^2 + 733*s)*(s^2 + (733*s)/5000 + 4687/10000));
% Gc12 = -(4687*((3535000*s)/128518487 + 19880000/128518487)*(10000*s^2 + 1466*s + 4687))/(20000*(5000*s^2 + 733*s)*(s^2 + (733*s)/5000 + 4687/10000));
% Gc21 = (14506265*(10000*s^2 + 1466*s + 4687))/(24560536*(5000*s^2 + 733*s)*(s^2 + (733*s)/5000 + 4687/10000));
% Gc22 = (4687*((15475000*s)/128518487 + 180000/128518487)*(10000*s^2 + 1466*s + 4687))/(20000*(5000*s^2 + 733*s)*(s^2 + (733*s)/5000 + 4687/10000));
% G_C = [Gc11 Gc12; Gc21 Gc22];


Ly = sys_as_tf * G_C;
T_y = (eye(2) + Ly)^(-1) * Ly; % Complementary sensitivity function
Y = G_C * (eye(2) + Ly)^(-1);

bode(T_y)