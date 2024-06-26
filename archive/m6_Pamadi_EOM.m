u0 = 1;

c1 = CX_alpha_dot;
m1 = 2*mass / (rho * U_0 * S);
eta1 = CX_alpha_dot*c1 / (m1 - CZ_alpha_dot*c1);
eta2 = Cm_alpha_dot*c1 / (m1 - CZ_alpha_dot*c1);


a11 = CX_u + eta1*CZ_u;
a12 = CX_alpha + eta1*CZ_alpha;
a13 = CX_q*c1 + eta1*(m1 + CZ_q*c1);
a14 = CX_theta + eta1*CZ_theta;

a21
a22
a23
a24

a31
a32
a33
a34

a41
a42
a43
a44

A = [
    a11 a12 a13 a14;
    a21 a22 a23 a24;
    a31 a32 a33 a34;
    a41 a42 a43 a44;
    ];

B = [
    b11 b12
    b21 b22
    b31 b32
    b41 b42
    ];

