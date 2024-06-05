clc; clearvars;
%% main.m
% this is the unifying script that runs all other scripts to produce a
% longitudinal EOM system
% - GEOMETRY: a "bare" aircraft with geometric information
%
% - AERODYNAMICS: aerodynamics parameters (airfoil lift curve, etc, is added to the
% aircraft
%
% - NONDIMENSIONAL_DERIVATIVES = GEOMETRY + AERODYNAMICS: with these sets
% of information the aircraft nondimensional derivatives can be calculated,
% as well as a trim condition.
%
% - TRIM_CONDITION = NONDIMENSIONaL_DERIVATIVES + DESIRED AOA;
%
% - DIMENSIONAL_DERIVATIVES = NONDIMENSIONAL_DERIVATIVES + TRIM_CONDITION:
% with the trim condition and the nondimensional derivatives, we can
% calculate dimensional derivatives about this trim condition, which can be
% used to create a dynamics model at the given condition.

% useful constants:
rho = 1.225; % air density
g = 9.81;
deg2rad = pi/180;

% define an empty aircraft struct, which we will add to
bare_ac = struct;

% fill the airframe with geometric information
ac = fill_model_geometry(bare_ac);

% fill the aircraft with aerodynamic parameters
ac.x_cg             = 0.3; % aircraft center of gravity location as a percentage of chord length
ac.x_ac             = 0.25; % aircraft aerodynamic center location as a percentage of chord length

%%%%% CHANGE THIS FOR DIFFERENT TRIM CONDITIONS %%%%
ac.alpha_trim_deg   = 5;
ac.alpha_trim       = ac.alpha_trim_deg*deg2rad; % desired trim AOA (you can change this to get different dynamics)
alpha_condition = string(ac.alpha_trim_deg);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ac.i_wing           = 0*deg2rad; % wing incidence angle
ac.i_tail           = -5*deg2rad; % tail incidence angle

ac.wing_airfoil     = 'Selig4083'; 
ac.Cl_alpha_airfoil = 5.95;
ac.alpha_0_wing     = -2.5*deg2rad;

ac.tail_airfoil     = 'NACA0006';
ac.Cl_alpha_airfoil_tail = 5.7296;
ac.alpha_0_tail     = 0*deg2rad;

ac.eta              = 0.85; % tail efficiency factor
ac.e                = 0.8; % span efficiency factor
ac.tau_e            = 0.8; % elevator effectiveness factor

%% Calculations from parameters defined above
% If desired, make modifications to the ac before these scripts below get
% run:
%
% - for instance, try doubling the Iyy and seeing the influence on stability!
% ac.Iyy = 2*ac.Iyy; % will ovewrite the prescribed values to ellicit different
%
% - or increasing or decreasing the baseline tail length:
% ac.geom.l_tail = 2*ac.geom.l_tail;
%
% - or changing the alpha desired value
% ac.alpha_trim = 5*deg2rad;
% dynamics;

% calculate nondimensional derivatives
nondim_derivatives

% calculate dimensional derivatives
dimensional_derivatives;

% calculate longitudinal EOM models
longitudinal_eom;
ac.mimo_system = sys_mimo_2x2;
ac = orderfields(ac);
save('saved_trim_states/' + alpha_condition + '_alpha_trim')