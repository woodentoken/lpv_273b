function [loop_transfer_functions, loop_poles, loop_stable] = hinfloop(Gss, weight_struct)
% HINFLOOP Compute all relevant loop transfer functions of a MIMO system
% using an H infinity controller
%
% INPUTS:
% - *Gss* (state space system): Plant, G, in state space form (hence, Gss)
% - *weight_struct*: a struct that contains vectors for each of the
% weighting filters
% - *weight_struct.wd* (vector): Weighting vector for the Delta filter, affects the Ty performance
% primarily 
% - *weight_struct.wp* (vector): Weighting vector for the performance filter, affects the Sy performance
% primarily 
% - *weight_struct.wu* (vector): Weighting vector for the actuation filter, affects the Youla
% TFM primarily. Currently, accepts only a single entry.
%
% OUTPUTS: 
% - *loop_transfer_functions* (struct): a structure with each of the relevant loop
% transfer functions as separate keys. Should return all the possible loop
% transfer functions in a minimal realization. Many of these are computed
% via the loopsens function, some are computed by hand
% - *loop_poles* (vector): the poles of the closed loop system
% - *loop_stable* (boolean): the status of the stability of the system

%% Load the data from the state space system
Wd_vec = weight_struct.wd;
Wp_vec = weight_struct.wp;
Wu_vec = weight_struct.wu;

Gp = tf(Gss);
[Ag, Bg, Cg, Dg] = ssdata(Gss);

%% D uncertainty filter (T)
W_delta = makeweight(Wd_vec(1), Wd_vec(2), Wd_vec(3));
W_d = tf(W_delta);
W_dtf = [W_d 0; 0 W_d];
W_d_ss = ss(W_dtf);
[Ad, Bd, Cd, Dd] = ssdata(W_d_ss);

%% P Performance filter (S)
W_p = makeweight(Wp_vec(1), Wp_vec(2), Wp_vec(3));
W_p = tf(W_p);
W_ptf = eye(size(Gss,1))*W_p;
W_p_ss = ss(W_ptf);
[Ap, Bp, Cp, Dp] = ssdata(W_p_ss);

%% Y actuation filter (Y)
W_y_mag = Wu_vec(1);
W_y_num = {W_y_mag 0; 0 W_y_mag};
W_y_den = {1 1; 1 1};

W_ytf = tf(W_y_num, W_y_den);
%W_y = eye(3,2);
W_y_ss = ss(W_ytf);
[Au, Bu, Cu, Du] = ssdata(W_y_ss);

%% augment the plant matrix with the filters
[A, B1, B2, C1, C2, D11, D12, D21, D22] = augss(...
    Ag, Bg, Cg, Dg, ...
    Ap, Bp, Cp, Dp, ...
    Au, Bu, Cu, Du, ...
    Ad, Bd, Cd, Dd ...
    );

B = [B1   B2];
C = [C1 ; C2];
D = [D11 D12; D21 D22];

G_augmented = ss(A,B,C,D);

%% compute Hinf controller (Gc)
[Gc, T_zw, gamma] = hinfsyn(G_augmented, size(Gss.A, 1), size(Gss.A, 2));

[Ac, Bc, Cc, Dc] = ssdata(Gc);
Gcss = ss(Ac, Bc, Cc, Dc);
Gcss = minreal(Gcss);
T_zw = minreal(T_zw);

%% loop transfer function matrices
ltf = loopsens(Gss, Gcss);
loop_poles = ltf.Poles;
loop_stable = ltf.Stable;
ltf = rmfield(ltf, 'Poles');
ltf = rmfield(ltf, 'Stable');

% rename struct fields for better agreement with literature
oldnames = {'Si', 'Ti', 'Li', 'So', 'To', 'Lo'};
newnames = {'Su', 'Tu', 'Lu', 'Sy', 'Ty', 'Ly'};
loop_transfer_functions = ltf;
for k=1:length(oldnames)
    loop_transfer_functions.(newnames{k}) = ltf.(oldnames{k});
    loop_transfer_functions = rmfield(loop_transfer_functions, oldnames{k});
end

% add some matrices to the struct to ensure we have everything we want in
% one place
loop_transfer_functions.Gc = Gcss;
loop_transfer_functions.Gp = Gss;
loop_transfer_functions.Y = minreal(loop_transfer_functions.Su*Gcss);
loop_transfer_functions.Wd = W_dtf;
loop_transfer_functions.Wp = W_ptf;
loop_transfer_functions.Wu = W_ytf;
loop_transfer_functions.Tzw = T_zw;

% compute and save the minimal realizations of each tf
loop_fields = fieldnames(loop_transfer_functions);
for i = 1:length(loop_fields)
    loop_transfer_functions.(loop_fields{i}) = minreal(loop_transfer_functions.(loop_fields{i}));
end

loop_transfer_functions.gamma = gamma; % robustness measurement

% sort the fields for ease of use
loop_transfer_functions = orderfields(loop_transfer_functions);
end