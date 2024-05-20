
 
% longitudinal dynamical system
% E xdot = A x + B u
% acceleration coefficient matrix (inertial matrix)
E = [
    [m  0          0   0];
    [0  m - Zw_dot 0   0];
    [0 -Mw_dot     Iyy 0];
    [0  0          0   1];
    ];

% state vector = [forward speed, vertical speed, pitch rate, pitch angle];
A_hat = [
    [Xu   Xw    Xq   -m*g];
    [Zu   Zw    1     0  ];
    [Mu   Mw    Mq    0  ];
    [0    0     1     0  ];
]; % 4 x 4

% control vector = [elevator deflection, thrust command];
B_hat = [
    [Xdel_e   Xdel_T];
    [Zdel_e   Zdel_T];
    [Mdel_e   Mdel_T];
    [0        0     ];
]; % 4 x 2

A = A_hat/E;
B = B_hat/E;
C=eye(4); % assume perfect state knowledge
D=0*eye(4);

% 4DOF longitudinal system
longitudinal_system = ss(A, B, C, D);