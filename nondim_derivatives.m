%% nondimensional derivatives
% these derivatives are a function of
% - geometry
% the trim condition can be obtained once the desired aoa and
% nondimensional derivatives are known

%% wing parameters
% wing airfoil parameters (Selig 4083)

% wing parameters
CL_alpha_wing   = ac.Cl_alpha_airfoil/(1 + ac.Cl_alpha_airfoil/(pi*ac.geom.AR)); % 3D relation from 2D lift curve
CL_0_wing       = CL_alpha_wing*abs(ac.alpha_0_wing);
CL_wing         = CL_0_wing + CL_alpha_wing*ac.alpha_trim;

Cm_ac_wing      = -0.085; % selig 4083 pitching moment at alpha = 0
Cm_0_wing       = Cm_ac_wing + CL_0_wing*(ac.x_cg - ac.x_ac);
Cm_alpha_wing   = CL_alpha_wing*(ac.x_cg- ac.x_ac);

%% tail parameters
% related parameters
e_0         = (2*CL_0_wing)/(pi*ac.geom.AR); % tail downwash angle (radians)
dedalpha    = (2*CL_alpha_wing)/(pi*ac.geom.AR); % downwash gradient

% tail parameters
alpha_tail      = ac.alpha_trim - ac.i_wing - e_0 + ac.i_tail; % downwash changes this
CL_alpha_tail   = ac.Cl_alpha_airfoil_tail/(1 + ac.Cl_alpha_airfoil_tail/(pi*ac.geom.AR_tail));
CL_0_tail       = CL_alpha_tail*abs(ac.alpha_0_tail); % zero due to symmetric tail
CL_tail         = CL_0_tail + CL_alpha_tail*(alpha_tail);

Cm_0_tail       = ac.eta * ac.geom.V_tail * CL_alpha_tail*(e_0 + ac.i_wing - ac.i_tail);
Cm_alpha_tail   = -ac.eta * ac.geom.V_tail * CL_alpha_tail * (1-dedalpha);

Cm_alpha_fuselage = 0; % assumed negligible

%% WHOLE AIRCRAFT coefficients
CL_alpha = CL_alpha_wing + ac.eta*(ac.geom.S_tail/ac.geom.S)*CL_alpha_tail;
CL_0 = CL_0_wing + ac.eta*(ac.geom.S_tail/ac.geom.S)*CL_0_tail;
CL = CL_wing + ac.eta*(ac.geom.S_tail/ac.geom.S)*CL_tail;

CD_0 = 0.05183; % estimated using aerosandbox
CD_alpha = (2*CL*CL_alpha_wing)/(pi*ac.e*ac.geom.AR); % not sure exactly where this came from...
CX_alpha = CD_alpha;
CD = CD_0 + CD_alpha*ac.alpha_trim;

Cm_0            = Cm_0_wing + Cm_0_tail;
Cm_alpha        = Cm_alpha_wing + Cm_alpha_fuselage + Cm_alpha_tail;

%% STABILITY DERIVATIVES
% nondimensional longitudinal stability derivatives (see Nelson page 116)
% u derivatives
M = 0; % assumption of negligble MACH number
% u
CT_u = -CD_0; % assumption
CL_u = CL_0*M^2/(1-M^2);

CD_u = 0;
CX_u = -1*(CD_u + 2*CD_0) + CT_u;
CZ_u = -CL_u - 2*CL_0; % mach probably doesn't matter, in which case
Cm_u = 0; % assumed 0

% alpha
CX_alpha = CL_0*(1 - (2*CL_alpha)/(pi*ac.geom.AR*ac.e));
CZ_alpha = -(CL_alpha + CD_0);

%% RATE DERIVATIVES
%% q derivatives
CX_q = 0; % assumed negligible
CL_q = 2*CL_alpha_tail*ac.eta*ac.geom.V_tail * (1.1); % Nelson 112, scaled by 1.1, same as Smac.etana
CZ_q = -CL_q; % Nelson 112, scaled by 1.1
Cm_q = CZ_q * (ac.geom.l_tail/ac.geom.c_bar); % Nelson 113. scaled by 1.1

%% alpha dot derivatives
CX_alpha_dot = 0;
CL_alpha_dot = 2*ac.eta*CL_alpha_tail*ac.geom.V_tail*dedalpha * (1.1);
CZ_alpha_dot = -CL_alpha_dot; % Nelson 114, scaled by 1.1 for whole aircraft
Cm_alpha_dot = CZ_alpha_dot * (ac.geom.l_tail/ac.geom.c_bar); % Nelson 115

%% CONTROL DERIVATIVES
CX_del_e = - ((0.155 - .047)/(20*pi/180)) * (ac.geom.S_tail/ac.geom.S); % Smac.etana approximation by way of Watkiss thesis
CD_del_e = - CX_del_e; % Smac.etana approximation by way of Watkiss thesis
CL_del_e = (ac.geom.S_tail/ac.geom.S) * ac.eta * CL_alpha_tail * ac.tau_e;
CZ_del_e = - CL_del_e; % Nelson 65
Cm_del_e = CZ_del_e * (ac.geom.l_tail/ac.geom.c_bar); % Nelson 65

% these are all assumed/prescribed - the thrust "input" is arbitrary anyway
CX_del_T = 0.01;
CZ_del_T = 0.001;
Cm_del_T = 0.001;

%% Trim determination

% determine elevator to counter moment
del_e_trim = -(Cm_0 + Cm_alpha*ac.alpha_trim)/Cm_del_e;
del_e_trim_deg = del_e_trim*180/pi;

% determine moment about cg
Cm_ac = Cm_0 + Cm_alpha*ac.alpha_trim + Cm_del_e*del_e_trim; % must be zero

% determine lift
CL_ac = CL_0 + CL_alpha*ac.alpha_trim + CL_del_e*del_e_trim;

% determine the velocity required to produce enought lift to counter weight
ac.u_0 = sqrt(ac.mass*9.81/(ac.geom.S*CL_ac*0.5*rho));
ac.Q = 0.5 * rho * ac.u_0^2; % dynamic pressure

CD_ac = CD_0 + CD_alpha*ac.alpha_trim + CD_del_e*abs(del_e_trim); % assume drag is countered by thrust

% keep track trim conditions
ac.trim.moment = ac.Q*ac.geom.S*Cm_ac; % must be 0 (N*m)
ac.trim.lift = ac.Q*ac.geom.S*CL_ac; % must be countered by weight (N)
ac.trim.drag = ac.Q*ac.geom.S*CD_ac; % must be countered by thrust (N)
ac.trim.elevator = del_e_trim_deg;
ac.trim.airspeed = ac.u_0;
ac.trim.alpha = ac.alpha_trim;

%% DERIVED PARAMETERS
ac.x_np = ac.x_ac + ac.eta*ac.geom.V_tail*(CL_alpha_tail/CL_alpha_wing)*(1-dedalpha);
ac.static_margin = ac.x_np - ac.x_cg; % positive static margin implies static stability