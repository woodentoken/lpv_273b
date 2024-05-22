%% longitudinal dynamical system from dimensional derivatives
% E xdot = A x + B u
% acceleration coefficient matrix (inertial matrix)

% state vector = [forward speed, vertical speed, pitch rate, pitch angle];
A = [
    [Xu   Xw    Xq   -g];
    [Zu   Zw    ac.u_0   0  ];
    [Mu+Mw_dot*Zu   Mw+Mw_dot*Zu    Mq+Mw_dot*ac.u_0    0  ];
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
rank(ctrb(A,B));

% transfer function matrices
elevator_tfm = ss2tfm(A,B,C,D,1);
thrust_tfm = ss2tfm(A,B,C,D,2);