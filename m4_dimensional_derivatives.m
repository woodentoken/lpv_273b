% 1 model_geometry.m
% 2 derived-quantities.m
% 3 Nelson_nd_derivatives.m
% 4 **dimensional_derivatives.m**
% 5 longitudinal_eom.m

% run the "baseline" case
m3_Nelson_nd_derivatives

% clearvars; Nelson_example; % uncomment this to test this case
% This is a verification case, it is based on an example given in Nelson
% (1998) Flight Stability and Control. This verifies that the matrices and
% coefficients are being calculated correctly, the correct values from
% Nelson are:
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
% dimensional longitudinal stability derivatives (see Nelson)
Xu         = -(CD_u + 2*CD_0) * (1/u_0)*Q*S/m;
Xw         = -1*(CD_alpha - CL_0) * Q*S/(m*u_0);
Xq         = 0;

Zu         = -1*(CL_u + 2*CL_0) * Q*S/(m*u_0);
Zw         = -1*(CL_alpha + CD_0) * Q*S/(m*u_0);
Zw_dot     = -CZ_alpha_dot * Q*S/(u_0*m) * (c_bar/2*u_0);
Zalpha     = u_0 * Zw;
Zalpha_dot = u_0 * Zw_dot;
Zq         = - CZ_q  * (c_bar/(2*u_0))*Q*S;

Mu         = Cm_u * (Q*S*c_bar/(u_0*Iyy));
Mw         = Cm_alpha * (Q*S*c_bar)/(u_0*Iyy);
Mw_dot     = Cm_alpha_dot * (c_bar/(2*u_0)) * (Q*S*c_bar/(u_0*Iyy));
Ma         = u_0 * Cm_alpha;
Ma_dot     = u_0 * Cm_alpha_dot;
Mq         = Cm_q * (c_bar/(2*u_0)) * (Q*S*c_bar/Iyy);

% longitudinal control derivatives
Xdel_e     = CX_del_e * (Q*S*c_bar)/Iyy;
Xdel_T     = CX_del_T * (Q*S*c_bar)/Iyy;

Zdel_e     = - CZ_del_e * (Q*S)/m;
Zdel_T     = - CZ_del_T * (Q*S)/m;

Mdel_e     = Cm_del_e * (Q*S*c_bar)/Iyy;
Mdel_T     = Cm_del_T * (Q*S*c_bar)/Iyy;
