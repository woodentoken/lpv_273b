% determine estimates of the aerodynamic coefficients analytically with
% approximations from geometry

%% Trim
% X trim
W*sin(theta_0) + X_wing;

% Z trim
Z_wing + Z_tail - W*cos(theta_0);

% M trim
M_ac_w + Z_wing*(x_cg - x_w) + N_h*(x_cg - x_h);

C_X = -W*sin(theta_0)/(0.5*rho*V^2*S);

C_Z = 
