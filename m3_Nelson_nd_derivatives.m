% 1 model_geometry.m
% 2 derived-quantities.m
% 3 **Nelson_nd_derivatives.m**
% 4 dimensional_derivatives.m
% 5 longitudinal_eom.m

% load the model_geometry file:
m2_derived_quantities

% determine estimates of the nondimensional aerodynamic coefficients 
% analytical coefficients using approximations from geometry
x_cg_ac = 0.3; % percent of chord
x_ac_wing = 0.25; % assumed quarter chord point; percent of chord
x_ac = x_ac_wing; % percent of chord

%% wing parameters
i_wing          = 0*pi/180; % wing incidence angle radians
Cl_alpha_airfoil = 5.95; % lift vs alpha slope of a selig 4083
alpha_0_wing    = -2.5*pi/180;

% wing airfoil parameters (Selig 4083)
CL_alpha_wing   = Cl_alpha_airfoil/(1 + Cl_alpha_airfoil/(pi*AR)); % 3D relation from 2D lift curve
CL_0_wing       = CL_alpha_wing*abs(alpha_0_wing);

% wing parameters
Cm_ac_wing      = -0.085; % selig 4083 pitching moment at alpha = 0
Cm_0_wing       = Cm_ac_wing + CL_0_wing*(x_cg_ac - x_ac_wing);
Cm_alpha_wing   = CL_alpha_wing*(x_cg_ac - x_ac_wing);

%% tail parameters
% related parameters
i_tail      = -5*pi/180; % tail incident angle radians
eta         = 0.9; % ratio of tail to wing dynamic pressure - here derived from empirical table
e_0         = (2*CL_0_wing)/(pi*AR); % tail downwash angle (radians)
dedalpha    = (2*CL_alpha_wing)/(pi*AR); % downwash gradient

% tail airfoil parameters(NACA 0006)
Cl_alpha_airfoil_tail = 5.7296; % lift vs alpha slope of NACA0006
alpha_0_tail = 0; % symmetric airfoil produce no lift at alpha = 0

% tail parameters
CL_alpha_tail   = Cl_alpha_airfoil_tail/(1 + Cl_alpha_airfoil_tail/(pi*AR_tail));
CL_0_tail       = CL_alpha_tail*abs(alpha_0_tail); % zero due to symmetric tail

Cm_0_tail       = eta * V_tail * CL_alpha_tail*(e_0 + i_wing - i_tail);
Cm_alpha_tail   = -eta * V_tail * CL_alpha_tail * (1-dedalpha);

Cm_alpha_fuselage = 0; % assumed negligible

%% WHOLE AIRCRAFT coefficients
alpha_trim = 5.8868*pi/180; % radians

CL_0            = CL_0_wing + CL_0_tail;
CL_alpha        = CL_alpha_wing + CL_alpha_tail;
CL = CL_0 + CL_alpha*alpha_trim;

CD_0 = 0.05183; % derived using aerosandbox
CD_alpha = CL_0 - (CL_0*CL_alpha)/(pi*e*AR);
CX_alpha = CD_alpha;
CD = CD_0 + CD_alpha*alpha_trim;

Cm_0            = Cm_0_wing + Cm_0_tail;
Cm_alpha        = Cm_alpha_wing + Cm_alpha_fuselage + Cm_alpha_tail;
Cm = Cm_0 + Cm_alpha*alpha_trim;

Cm_alpha_fuselage = 0; % assumed 0

%% STABILITY DERIVATIVES
% u derivatives
M = 0; % assumption
% u
CT_u = -CD_0; % assumption
CL_u = CL_0*M^2/(1-M^2);

CD_u = 0;
CX_u = -1*(CD_u + 2*CD_0) + CT_u;
CZ_u = -CL_u - 2*CL_0; % mach probably doesn't matter, in which case
Cm_u = 0; % assumed 0

% alpha
CX_alpha = CL_0*(1 - (2*CL_alpha)/(pi*AR*e));
CZ_alpha = -(CL_alpha + CD_0);

%% RATE DERIVATIVES
%% q derivatives
CX_q = 0; % assumed negligible
CL_q = 2*CL_alpha_tail*eta_tail*V_tail * (1.1); % Nelson 112, scaled by 1.1
CZ_q = -CL_q; % Nelson 112, scaled by 1.1
Cm_q = CZ_q * (l_tail/c_bar); % Nelson 113. scaled by 1.1

%% alpha dot derivatives
CX_alpha_dot = 0;
CL_alpha_dot = 2*eta_tail*CL_alpha_tail*V_tail*dedalpha * (1.1);
CZ_alpha_dot = -CL_alpha_dot; % Nelson 114, scaled by 1.1 for whole aircraft
Cm_alpha_dot = CZ_alpha_dot * (l_tail/c_bar); % Nelson 115

%% CONTROL DERIVATIVES
tau_e = 0.8;
CX_del_e = 0; % assumed 0
CL_del_e = (S_tail/S_exposed_wing) * eta_tail * CL_alpha_tail * tau_e;
CZ_del_e = - CL_del_e; % Nelson 65
Cm_del_e = CZ_del_e * (l_tail/c_bar); % Nelson 65

CX_del_T = 0.1;
CZ_del_T = 0;
Cm_del_T = 0;

%% WHOLE AIRCRAFT
del_e_trim = 0;

CL_ac = CL_0 + CL_alpha*alpha_trim + CL_del_e*del_e_trim;
CD_ac = CD_0 + CD_alpha*alpha_trim + CX_del_e*del_e_trim;
Cm_ac = Cm_0 + Cm_alpha*alpha_trim + Cm_del_e*del_e_trim;

%% DERIVED PARAMETERS
x_np = x_ac + eta*V_tail*(CL_alpha_tail/CL_alpha_wing)*(1-dedalpha);

%% flight conditions;
m = mass;
c = chord;
c_bar = mean_chord_exposed_wing;

g = 9.81;

u_0 = 10.0445; % trim airspeed
rho = 1.225; % air density
Q = 0.5 * rho * u_0^2; % dynamic pressure