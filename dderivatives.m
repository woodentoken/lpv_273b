ndderivatives;
rho = 1.225; % air density
Q = 0.5 * rho * u_0^2; % dynamic pressure

% condition constants
mu_force =  (Q * S)                           / u_0;
mu_moment = (Q * S * mean_chord_exposed_wing) / u_0;

% dimensional longitudinal stability derivatives (see Nelson)
Xu         = -1 * mu_force * (CD_u + 2*CD_0);
Xw         = -1 * mu_force * (CD_alpha - CL_0);
Xq         = 0;

Zu         = -1 * mu_force*(CL_u + 2*CL_0);
Zw         = -1 * mu_force*(CL_alpha + CD_0);
Zw_dot     = CL_alpha_dot * mu_force * (chord/2*u_0);
Zalpha     = u_0 * Zw;
Zalpha_dot = u_0 * Zw_dot;
Zq         = CL_q * mu_force * (chord/2);

Mu         = Cm_u * mu_moment;
Ma         = Cm_alpha * mu_moment;
Ma_dot     = Cm_alpha_dot * mu_moment * chord/(2*u_0);
Mq         = Cm_q * mu_moment * (chord/2);

% longitudinal control derivatives
Zdel_e     = CZ_del_e*mu_force*u_0;
Zdel_T     = 0;
Mdel_e     = Cm_del_e * mu_moment;
Mdel_T     = 0;
Xdel_e     = 0;
Xdel_T     = 0;