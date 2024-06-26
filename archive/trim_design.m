% calculate the non dimensional derivatives
m3_Nelson_nd_derivatives

rho = 1.225;
mass = 0.5;

%% WHOLE AIRCRAFT + CONTROL coefficients
alpha = 0;
del_e = 0;

CL = CL_0 + CL_alpha*alpha + CZ_del_e*del_e;
Cm = Cm_0 + Cm_alpha*alpha + Cm_del_e*del_e;

% decide what angle we want to trim at
alpha_trim = 1*pi/180;
% calculate the require elevator for the moment condition
del_e_trim = -(Cm_0 + Cm_alpha*alpha_trim)/Cm_del_e;
del_e_trim_deg = del_e_trim*180/pi;

% confirm moment at trim is 0
Cm = Cm_0 + Cm_alpha*alpha_trim + Cm_del_e*del_e_trim;

% calculate trim lift coefficient
CL = CL_0 + CL_alpha*alpha_trim + CZ_del_e*del_e_trim;

u_0 = sqrt(mass*9.81/(S*CL*0.5*rho))