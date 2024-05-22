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
CD_0 = 0;
CDi = k*CL^2;
CD = CD_0 + CDi;


% q derivatives
CD_q = 0; % assumed negligible

CL_q_B = 2*CL_alpha_B*(1-(x_cg/l_fuselage));
fuselage_apparent_mass_coefficient = 0.8; % estimated from empirical data;

CL_alpha_B = 2 * fuselage_apparent_mass_coefficient;
CL_q_wing = (0.5 + 2*eta)*(CL_alpha_wing);
CL_q_WB = (K_WB + K_BW)*((S_exposed_wing * mean_chord_exposed_wing) / (S_wing * mean_chord_wing))*CLq_wing + CLq_B;
CL_q = CLq_WB;

% simplified Nelson approach
CL_q_tail = -2 * CL_alpha_tail * V_tail * eta_tail % Nelson 112
CL_q = 1.1 * CL_q_tail; % Nelson 113

Cmq_tail = -2 * CL_alpha_tail * V_tail * eta_tail * (l_tail/mean_chord_exposed_wing); % Nelson 113
Cmq = 1.1* Cmq_tail; % Nelson 113

% alpha dot derivatives
CD_alpha_dot = 0; % assumed negligible

K_A = (1/AR) - (1/(1+AR)^(1.7));
K_lambda = (10 - 3*lambda)/7;
K_H = (1 - height_tail/b) / ((2*l_tail)/b)^(1/3);
downwash_gradient_thorough = 4.44 * (K_A * K_lambda * K_H * sqrt(cos(Lambda_quarter_chord))^(1.19));
downwash_gradient_simple = 2*a_wing/(pi*AR);


C_f_wing = 0.007; % turbulent flat plate skin friction coefficient, empirical
R_L_S = 1.05; % parameter dependent on the sweep angle chord location of maximum thickness ratio, empirical
CD_0_wing = C_f_wing*(1 + L_thickness_location_parameter) + 100*(thickness_ratio)^4)*R_L_S*(S_exposed/S);
eta = 1 - (2.42*sqrt(CD_0_wing))/((l_tail/mean_chord_wing)+0.30);

CL_alpha_dot_tail = 2 * a_tail * V_t * eta * downwash_gradient_simple;
CL_alpha_dot_body = 0; % assumed negligible due to short fuselage
CL_alpha_dot = CL_alpha_dot_tail + CL_alpha_dot_body;

Cm_alpha_dot_body = 0; % assumed negligible due to short fuselage
Cm_alpha_dot_tail = Cmq_tail*(l_tail/mean_chord_exposed_wing);
Cm_alpha_dot = Cm_alpha_dot_tail + Cm_alpha_dot_body;

% control derivatives
tau_e = 
CM_del_e = -CL_alpha_tail*eta_tail*V_t*(b_exposed_wing/b_tail)*tau_e;
CL_del_e = -CL_alpha_tail*eta_tail*V_t*(b_exposed_wing/b_tail)*tau_e;
