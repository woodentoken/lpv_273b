clearvars;
clear ac;
ac = struct();

ac.u_0 = 176;
rho = 0.002378;

g = 32.2;

ac.Q = 0.5*rho*ac.u_0^2;
ac.geom.S = 184;
ac.geom.c_bar = 5.7;

ac.W = 2750;
ac.mass = 2750/32.2;

ac.Ixx = 1048;
ac.Iyy = 3000;
ac.Izz = 3530;

ac.x_cg = 0.295; % percent chord

CD_u = 0;
CD_0 = 0.05;
CT_u = -CD_0;
CX_u = 1*(CD_u + 2*CD_0) + CT_u;

CL_u = 0;
CL_0 = 0.41;
Cm_u = 0;

CD_alpha = 0.33;
CL_alpha = 4.44;

CZ_alpha_dot = 0;
Cm_alpha = -0.683;
Cm_alpha_dot = -4.36;

CZ_q = 0;
Cm_q = -9.96;

CX_del_e = 0;
CZ_del_e = 0;

CX_del_T = 0;
CZ_del_T = 0;

Cm_del_e = 0;
Cm_del_T = 0;




