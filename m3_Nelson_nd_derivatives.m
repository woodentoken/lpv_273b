% 1 model_geometry.m
% 2 derived-quantities.m
% 3 **Nelson_nd_derivatives.m**
% 4 dimensional_derivatives.m
% 5 longitudinal_eom.m

% load the model_geometry file:
m2_derived_quantities

% determine estimates of the nondimensional aerodynamic coefficients 
% analytical coefficients using approximations from geometry
x_cg_ac = 0.3;
x_ac_wing = 0.25; % assumed quarter chord point;

%% wing parameters
i_wing = 2*pi/180; % wing incidence angle radians
Cl_alpha_airfoil = 5.95; % lift vs alpha slope of a selig 4083
alpha_0_wing = -2.5*pi/180;

% wing airfoil parameters (Selig 4083)
CL_alpha_wing = Cl_alpha_airfoil/(1 + Cl_alpha_airfoil/(pi*AR)); % 3D relation from 2D lift curve
CL_0_wing = CL_alpha_wing*abs(alpha_0_wing);

% wing parameters
Cm_ac_wing = -0.085; % selig 4083 pitching moment at alpha = 0
Cm_0_wing = Cm_ac_wing + CL_0_wing*(x_cg_ac - x_ac_wing);
Cm_alpha_wing = CL_alpha_wing*(x_cg_ac - x_ac_wing);

%% tail parameters
% related parameters
i_tail = -5*pi/180; % tail incident angle radians
eta = 1; % ratio of tail to wing dynamic pressure - here derived from empirical table
e_0      = (2*CL_0_wing)/(pi*AR); % tail downwash angle (radians)
dedalpha = (2*CL_alpha_wing)/(pi*AR); % downwash gradient

% tail airfoil parameters(NACA 0006)
Cl_alpha_airfoil_tail = 5.7296; % lift vs alpha slope of NACA0006
alpha_0_tail = 0; % symmetric airfoil produce no lift at alpha = 0

% tail parameters
CL_alpha_tail = Cl_alpha_airfoil_tail/(1 + Cl_alpha_airfoil_tail/(pi*AR_tail));
CL_0_tail = CL_alpha_tail*abs(alpha_0_tail); % zero due to symmetric tail

Cm_0_tail = eta * V_tail * CL_alpha_tail*(e_0 + i_wing - i_tail);
Cm_alpha_tail = -eta * V_tail * CL_alpha_tail * (1-dedalpha);

%% aircraft coefficients
CL_0 = CL_0_wing + CL_0_tail;
CL_alpha = CL_alpha_wing + CL_alpha_tail;

Cm_0 = Cm_0_wing + Cm_0_tail;
Cm_alpha = Cm_alpha_wing + Cm_alpha_tail;

%Cm_alpha_wing = CL_alpha_wing*(x_cg-x_ac)/(c_bar);
Cm_alpha_fuselage = 0;
%Cm_alpha_tail = - eta_tail * V_tail * CL_alpha_tail * (1-dedalpha);

% sum the total alpha derivatives for the aircraft
%Cm_ac = Cm_alpha_wing + Cm_alpha_fuselage + Cm_alpha_tail;

%x_ac_fraction = 0.25;
%x_np_fraction = x_ac_fraction - Cm_alpha_fuselage/CL_alpha_wing + eta*V_t*(CL_alpha_tail/CL_alpha_wing)*(1 - dedalpha);

% finite lift coefficient from 2D lift slope
a = CL_alpha_wing/(1+(CL_alpha_wing/(pi*AR*e)));
%CL = a*alpha;
%Cm_0_tail = eta_tail * V_tail * CL_alpha_tail * (e)

% y intercept of wing lift curve slope

k = 1/(pi*e*AR);
CD_0 = 0.05183; % derived using aerosandbox
%CDi = k*CL^2;
CD = CD_0 + CL_alpha^2/(pi*AR*e);
CD_u = 0;

% u derivatives
M = 0;
CT_u = 1;
CX_u = -1*(CD_u + 2*CD_0) + CT_u;
CZ_u = - CL_0*M^2/(1-M^2) - 2*CL_0; % mach probably doesn't matter, in which case
Cm_u = 0; % assumed 0

% alpha derivatives
CX_alpha = CL_0 - (2*CL_0)/(pi*e)*(CL_alpha/AR);
CZ_alpha = -(CL_alpha + CL_0);
%Cm_alpha = CL_alpha_wing*(x_cg-x_ac)/(c_bar) + Cm_alpha_fuselage - eta_tail*V_tail*CL_alpha_tail*(1-dedalpha);

% q derivatives
CX_q = 0; % assumed negligible
CZ_q = 1.1*-2*eta_tail*CL_alpha_tail*V_tail; % Nelson 112
Cm_q = 1.1*-2*eta_tail*CL_alpha_tail*V_tail*l_tail/c_bar; % Nelson 113

% alpha dot derivatives
CX_alpha_dot = 0;
CZ_alpha_dot = 1.1*-2*eta_tail*CL_alpha_tail*V_tail*dedalpha; % Nelson 114
Cm_alpha_dot = 1.1*-2*eta_tail*CL_alpha_tail*V_tail*dedalpha*l_tail/c_bar; % Nelson 115

% control derivatives
tau_e = 0.8;
CX_del_e = 0;
CZ_del_e = (S_tail/S_exposed_wing) * eta_tail * CL_alpha_tail * tau_e; % Nelson 65
Cm_del_e = - eta_tail * V_t * CL_alpha_tail * tau_e; % Nelson 65

CX_del_T = 1;
CZ_del_T = 1;
Cm_del_T = 0;
