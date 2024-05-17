



A = [
    [CX_u-2*mu*Dc  CX_alpha                              CZ_0  CX_q];
    [CZ_u          CZ_alpha + (CZ_alpha_dot - 2*mu)*Dc  -CX_0  2*mu + CZ_q];
    [0             0                                    -Dc    1];
    [Cm_u          Cm_alpha + Cm_alpha_dot*Dc            0     Cm_q-2*mu*K_y^2*Dc];
];

B = [
    
];

C=eye(4); % assume perfect state knowledge
D=0*eye(4);

