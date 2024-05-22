% 1 model_geometry.m
% 2 derived-quantities.m
% 3 Nelson_nd_derivatives.m
% 4 dimensional_derivatives.m
% 5 **longitudinal_eom.m**

% call the dimensional derivatives script
m4_dimensional_derivatives
 
% longitudinal dynamical system
% E xdot = A x + B u
% acceleration coefficient matrix (inertial matrix)

% state vector = [forward speed, vertical speed, pitch rate, pitch angle];
A = [
    [Xu   Xw    Xq   -g];
    [Zu   Zw    u_0   0  ];
    [Mu+Mw_dot*Zu   Mw+Mw_dot*Zu    Mq+Mw_dot*u_0    0  ];
    [0    0     1     0  ];
]; % 4 x 4

% control vector = [elevator deflection, thrust command];
B = [
    [Xdel_e                 Xdel_T];
    [Zdel_e                 Zdel_T];
    [Mdel_e+Mw_dot*Zdel_e   Mdel_T+Mw_dot*Zdel_T];
    [0                      0     ];
]; % 4 x 2


C=eye(4); % assume perfect state knowledge
D=0*eye(4,2);

% 4DOF longitudinal system
longitudinal_system = ss(A, B, C, D);