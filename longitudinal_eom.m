%% longitudinal dynamical system from dimensional derivatives
% E xdot = A x + B u
% acceleration coefficient matrix (inertial matrix)

%% approximation of full longitudinal dynamics
% state vector = [forward speed, vertical speed, pitch rate, pitch angle];
A4 = [
    [Xu   Xw    Xq   -g];
    [Zu   Zw    ac.u_0   0  ];
    [Mu+Mw_dot*Zu   Mw+Mw_dot*Zu    Mq+Mw_dot*ac.u_0    0  ];
    [0    0     1     0  ];
]; % 4 x 4

% control vector = [elevator deflection, thrust command];
B4 = [
    [Xdel_e                 Xdel_T];
    [Zdel_e                 Zdel_T];
    [Mdel_e+Mw_dot*Zdel_e   Mdel_T+Mw_dot*Zdel_e];
    [0                      0     ];
]; % 4 x 2
C4=eye(4); % assume perfect state knowledge
D4=0*eye(4,2);


%% approximation of phugoid mode dynamics:
A_phugoid = [
    [Xu -g];
    [-Zu/ac.u_0 0];
];
B_phugoid = [
    [Xdel_e            Xdel_T];
    [-Zdel_e/ac.u_0   -Zdel_T/ac.u_0]
];
C_phugoid = eye(2);
D_phugoid = 0*eye(2);

% 4DOF longitudinal system
states_4x2 = {'delta u', 'delta w', 'pitch rate', 'delta pitch angle'};
states_2x2 = {'delta u', 'delta pitch angle'};

outputs_2x2 = states_2x2;
outputs_4x2 = states_4x2;

inputs = {'delta elevator', 'delta thrust'};

% define the "higher" 4x2 system
sys_mimo_4x2 = ss(A4,B4,C4,D4, 'statename', states_4x2, 'inputname', inputs, 'outputname', outputs_4x2);

% define the "lower" 2x2 system
sys_mimo_2x2 = ss(A_phugoid,B_phugoid,C_phugoid,D_phugoid, 'statename', states_2x2, 'inputname', inputs, 'outputname', outputs_2x2);
[N_elevator, D] = ss2tfm(A_phugoid, B_phugoid, C_phugoid, D_phugoid, 1)
[N_thrust, D] = ss2tfm(A_phugoid, B_phugoid, C_phugoid, D_phugoid, 2)

% transfer function matrices
tf_sys_mimo_2x2 = tf(sys_mimo_2x2);
if rank(ctrb(A_phugoid, B_phugoid)) == 2
    sprintf('the 2x2 system is fully controllable')
    eig_2x2 = eig(A_phugoid);
    [U,S,V] = svd(A_phugoid);
end