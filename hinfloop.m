function [loop_transfer_functions, loop_poles, loop_stable] = hinfloop(Gss, Wd_vec, Wp_vec, Wu_vec)
%HINFLOOP Summary of this function goes here
%   Detailed explanation goes here

% s = tf('s');
% G = 100*[s/(s+1) s/(s+1) 1/(s+1); 1/(s+1) 1/(s+1) 1/(s+1)];
% G = minreal(G);

%Gss = ss(G);
Gp = tf(Gss);
[Ag, Bg, Cg, Dg] = ssdata(Gss);

%% D uncertainty filter (T)
W_delta = makeweight(Wd_vec(1), Wd_vec(2), Wd_vec(3));
W_d = tf(W_delta);
W_dtf = [W_d 0; 0 0.5*W_d];
%W_dtf = eye(3,2);
W_d_ss = ss(W_dtf);
[Ad, Bd, Cd, Dd] = ssdata(W_d_ss);
%[Ad, Bd, Cd, Dd] = minreal(Ad, Bd, Cd, Dd);

%% P Performance filter (S)
W_p = makeweight(Wp_vec(1), Wp_vec(2), Wp_vec(3));
W_p = tf(W_p);
W_ptf = eye(size(Gss,1))*W_p;
%W_ptf = eye(3,2);
W_p_ss = ss(W_ptf);
[Ap, Bp, Cp, Dp] = ssdata(W_p_ss);
%[Ap, Bp, Cp, Dp] = minreal(Ap, Bp, Cp, Dp);

%% Y actuation filter (Y)
W_y_mag = 5;
W_y_num = {W_y_mag 0; 0 W_y_mag};
W_y_den = {1 1; 1 1};
W_ytf = tf(W_y_num, W_y_den);
%W_y = eye(3,2);
W_y_ss = ss(W_ytf);
[Au, Bu, Cu, Du] = ssdata(W_y_ss);
% Au=[];
% Bu=[];
% Cu=[];
% Du=[];
%[Au, Bu, Cu, Du] = minreal(Au, Bu, Cu, Du);

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

%% compute Hinf controller
[Gc, T_zw, gamma] = hinfsyn(G_augmented, size(Gss.A, 1), size(Gss.A, 2));

[Ac, Bc, Cc, Dc] = ssdata(Gc);
Kss = ss(Ac, Bc, Cc, Dc);
Kss = minreal(Kss);

%% matrices
ltf = loopsens(Gss, Kss);
loop_poles = ltf.Poles;
loop_stable = ltf.Stable;
ltf = rmfield(ltf, 'Poles');
ltf = rmfield(ltf, 'Stable');

% get minimum realization of every loop transfer function


% rename struct fields for better agreement with 273B
oldnames = {'Si', 'Ti', 'Li', 'So', 'To', 'Lo'};
newnames = {'Su', 'Tu', 'Lu', 'Sy', 'Ty', 'Ly'};
loop_transfer_functions = ltf;
for k=1:length(oldnames)
  loop_transfer_functions.(newnames{k}) = ltf.(oldnames{k});
  loop_transfer_functions = rmfield(loop_transfer_functions, oldnames{k});
end

loop_transfer_functions.Gc = Gc;
loop_transfer_functions.Gp = Gss;
loop_transfer_functions.Y = minreal(Kss*ltf.So);
loop_transfer_functions.Wd = W_dtf;
loop_transfer_functions.Wp = W_ptf;
loop_transfer_functions.Wu = W_ytf;
loop_transfer_functions.Tzw = T_zw;
loop_transfer_functions.gamma = gamma;

loop_fields = fieldnames(ltf);
for i = 1:length(loop_fields)
    ltf.(loop_fields{i}) = minreal(ltf.(loop_fields{i}));
end

loop_transfer_functions = orderfields(loop_transfer_functions);

%% confirming loopsens is equivalent to hand calculation
% Ly_l = ltf.Lo;
% Ly = Gss*Kss;
% %sigma(Ly, 'r', Ly_l, 'c--')
% 
% Ty_l = ltf.To;
% Ty = feedback(Ly, eye(2));
% %sigma(Ty, 'r', Ty_l, 'c--')
% 
% youla = minreal(Kss*ltf.So);
% %% plotting
% figure(1)
% subplot(3,1,1)
% sigma( ...
%     ltf.Lo, 'm', ...
%     G, '', ...
%     G_c, '' ...
%     )
% legend('Ly', 'Gp', 'Gc','Location', 'best')
% grid
% set(gca, 'Color','k', 'XColor','w', 'YColor','w');set(gcf, 'Color','k')
% 
% subplot(3,1,2)
% sigma( ...
%     ltf.Lo, 'w', ...
%     ltf.So, 'r', ...
%     W_ptf, 'r--', ...
%     ltf.To, 'c', ...
%     W_dtf, 'c--'...
%     )
% legend( 'Ly', 'Sy', 'Wp','Ty', 'Wd', 'Location', 'best')
% grid
% set(gca, 'Color','k', 'XColor','w', 'YColor','w');set(gcf, 'Color','k')
% 
% subplot(3,1,3)
% sigma( ...
%     Y, 'y', ...
%     W_ytf, 'g' ...
%     )
% legend('Y', 'Wy', 'Location', 'best')
% grid
% set(gca, 'Color','k', 'XColor','w', 'YColor','w');set(gcf, 'Color','k')
% 
% figure(2)
% step(ltf.To)
% title('closed loop step response')
% grid
% 
% figure(3)
% step(Y)
% title('actuator activity under step response')
% grid
% set(gca, 'Color','k', 'XColor','w', 'YColor','w');set(gcf, 'Color','k')
% %% plotting
% figure(11)
% sigma( ...
%     ltf.To, 'c', ...
%     ltf.So, 'r', ...
%     ltf.Si, 'y-.', ...
%     Y, 'm--' ...
%     )
% legend( 'Ty', 'Sy', 'Su', 'Y', 'Location', 'best')
% grid on
% set(gca, 'Color','k', 'XColor','w', 'YColor','w');set(gcf, 'Color','k')
% 
% figure(22)
% sigma( ...
%     G_c, 'w', ...
%     G, 'g', ...
%     ltf.Lo, 'c-.', ...
%     Y, 'm--' ...
%     )
% legend( 'Gc', 'Gp', 'Ly', 'Y', 'Location', 'best')
% grid on
% set(gca, 'Color','k', 'XColor','w', 'YColor','w');set(gcf, 'Color','k')
% 
% 
% 
end