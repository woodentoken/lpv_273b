% determine estimates of the nondimensional aerodynamic coefficients 
% analytically using approximations from geometry

% load the model_geometry file:
model_geometry

%% Trim

%stability derivatives
CD_u
CD_alpha

CL_alpha_nose = 2*(k2-k1)*S_body_max/S;
K_N = (CL_alpha_nose/CL_alpha_exposed)*S/S_exposed_wing;
CL_alpha_WB = (K_N + K_WB + K_BW) * CL_alpha_exposed * S_exposed/S;
CL_alpha = CL_alpha_WB; % assumed for subsonic flight;

Cm_u
Cm_alpha
Cm_tail = 

% finite lift coefficient from 2D lift slope
a = a0/(1+(a0/(pi*AR*e)));
CL = a*alpha;

k = 1/(pi*e*AR);
CD_0 = 0.05183; % derived using aerosandbox
%CDi = k*CL^2;
CD = CD_0 + CDi;

% u derivatives
CX_u = -1*(CD_u + 2CD_0) + CT_u;
CZ_u = -CL_0*M^2/(1-M^2) - 2*CL_0;
Cm_u = 0; % assumed 0

% alpha derivatives
CX_alpha = CL_0 - (2*CL_0)/(pi*e)*(CL_alpha/AR);
CZ_alpha = -(CL_alpha + CL_0);
Cm_alpha = CL_alpha_wing*(x_cg-x_ac)/(c_bar) + Cm_alpha_fuselage - eta_tail*V_tail*CL_alpha_tail*(1-downwash_gradient);

% q derivatives
CX_q = 0; % assumed negligible
CZ_q = 1.1*-2*eta_tail*CL_alpha_tail*V_tail;
Cm_q = 1.1*-2*eta_tail*CL_alpha_tail*V_tail*l_tail/c_bar;

% alpha dot derivatives
CX_alpha_dot = 0;
CZ_alpha_dot = 1.1*-2*eta_tail*CL_alpha_tail*V_tail*downwash_gradient;
Cm_alpha_dot = 1.1*-2*eta_tail*CL_alpha_tail*V_tail*downwash_gradient*l_Tail/c_bar;

% control derivatives
tau_e = 0.8;
CM_del_e = -CL_alpha_tail * eta_tail * V_t * (b_exposed_wing/b_tail) * tau_e;
CL_del_e = CL_alpha_tail * eta_tail * V_t * (b_tail/b_exposed_wing);
