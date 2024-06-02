%% dimensional derivatives
% function of:
% - geometry
% - nondimensional derivatives
% - flight condition

% clearvars; Nelson_example; % ****uncomment this to test the Nelson case****
% This is a verification case, it is based on an example given in Nelson
% (1998) Flight Stability and Control, page 158.
% This verifies that the matrices and coefficients are being calculated 
% correctly, the correct values from Nelson are:
% A = 
% -0.045  0.036       0.0000 -32.2
% -0.369  -2.02       176     0
%  0.0019 -0.0396    -2.948   0
%  0.0019 -0.0396    -2.948   0   
%  0.0000  0.0000     1.0000  0

% which produces these eigenvalues (eig(A)):
  % -2.5103 + 2.8668i
  % -2.5103 - 2.8668i
  % -0.0173 + 0.2183i
  % -0.0173 - 0.2183i



%% Dimensional Coefficients
% all of these are taken from 
% dimensional longitudinal stability derivatives (see Nelson page 150)
Xu         = -(CD_u + 2*CD_0) * (1/ac.u_0)*ac.Q*ac.geom.S/ac.mass;
Xw         = -1*(CD_ac - CL_0) * ac.Q*ac.geom.S/(ac.mass*ac.u_0);
Xq         = 0;

Zu         = -1*(CL_u + 2*CL_0) * ac.Q*ac.geom.S/(ac.mass*ac.u_0);
Zw         = -1*(CL_alpha + CD_0) * ac.Q*ac.geom.S/(ac.mass*ac.u_0);
Zw_dot     = -CZ_alpha_dot * ac.Q*ac.geom.S/(ac.u_0*ac.mass) * (ac.geom.c_bar/2*ac.u_0);
Zalpha     = ac.u_0 * Zw;
Zalpha_dot = ac.u_0 * Zw_dot;
Zq         = - CZ_q  * (ac.geom.c_bar/(2*ac.u_0))*ac.Q*ac.geom.S;

Mu         = Cm_u * (ac.Q*ac.geom.S*ac.geom.c_bar/(ac.u_0*ac.Iyy));
Mw         = Cm_alpha * (ac.Q*ac.geom.S*ac.geom.c_bar)/(ac.u_0*ac.Iyy);
Mw_dot     = Cm_alpha_dot * (ac.geom.c_bar/(2*ac.u_0)) * (ac.Q*ac.geom.S*ac.geom.c_bar/(ac.u_0*ac.Iyy));
Ma         = ac.u_0 * Cm_alpha;
Ma_dot     = ac.u_0 * Cm_alpha_dot;
Mq         = Cm_q * (ac.geom.c_bar/(2*ac.u_0)) * (ac.Q*ac.geom.S*ac.geom.c_bar/ac.Iyy);

% longitudinal control derivatives
Xdel_e     = CX_del_e * (ac.Q*ac.geom.S)/ac.mass;
Xdel_T     = CX_del_T * (ac.Q*ac.geom.S)/ac.mass;

Zdel_e     = CZ_del_e * (ac.Q*ac.geom.S)/ac.mass;
Zdel_T     = CZ_del_T * (ac.Q*ac.geom.S)/ac.mass;

Mdel_e     = Cm_del_e * (ac.Q*ac.geom.S*ac.geom.c_bar)/ac.Iyy;
Mdel_T     = Cm_del_T * (ac.Q*ac.geom.S*ac.geom.c_bar)/ac.Iyy;
