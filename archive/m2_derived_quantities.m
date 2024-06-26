% 1 model_geometry.m
% 2 **derived-quantities.m**
% 3 Nelson_nd_derivatives.m
% 4 dimensional_derivatives.m
% 5 longitudinal_eom.m

% load the model geometry file
m1_model_geometry

%% derived calculations (areas, etc.)
% wing calculations
inboard_wing_area = root_to_wrist * chord;

semiperimeter = (te_to_tip + le_to_tip + chord)/2;
outboard_wing_area = sqrt( ...
    semiperimeter* ...
    ((semiperimeter-te_to_tip)* ...
    (semiperimeter-le_to_tip)* ...
    (semiperimeter-chord)) ...
    );
half_wing_area = outboard_wing_area + inboard_wing_area;
wing_area = 2 * half_wing_area;

%% Final, aircraft quantities: %%
%% wing
% span b
b_wing = half_wingspan * 2 + body_width;
b_exposed_wing = half_wingspan * 2;

% chord
mean_chord_inboard = chord;

taper_ratio_outboard = (1*inches2meters)/chord; 
mean_chord_outboard = chord*(2/3)*(1 + taper_ratio_outboard + taper_ratio_outboard^2) / (1 + taper_ratio_outboard); % semiperimeter calculations

mean_chord_exposed_wing = (mean_chord_inboard*inboard_span + mean_chord_outboard*outboard_span)/(inboard_span + outboard_span);
mean_chord_wing = (mean_chord_inboard*(inboard_span+body_width/2) + mean_chord_outboard*outboard_span)/(inboard_span + (body_width/2) + outboard_span);
c_bar = mean_chord_exposed_wing;

% area S
S_exposed_wing = wing_area;
S = wingspan*mean_chord_wing;

% aspect ratio AR
AR_exposed = b_exposed_wing/mean_chord_exposed_wing;
AR = b_wing / mean_chord_wing;

%% tail
% span b
b_tail_spread = tail_length*sin(pi/3);
b_tail_furled = tail_width;

% chord
c_tail = tail_length;

% area S
spread_angle = 60;
S_tail = pi*tail_length^2*(spread_angle/360); % segment of a circle
S_tail_furled = 1.1*tail_length * tail_width;

% aspect ratio AR
AR_tail = b_tail_spread / tail_length;
AR_tail_furled = b_tail_furled / tail_length;

% other tail parameters
V_tail = (l_tail * S_tail) / (chord * S_exposed_wing); % tail volume coefficient

e = 1/(1.05 + 0.007*pi*AR); % oswald efficiency factor approximation
eta_tail = 0.8; % tail efficiency factor, ratio of dynamic pressures

%% Body
body_diameter_to_wingspan = body_width / (2*half_wingspan);
S_body_max = pi*body_width*body_depth;

%% Additional
% wing body empirical approximations for subsonic flight (these are used
% for Pamadi Approximations
apparent_mass_constant = 4; % empirical function of body_fineness_ratio
K_WB = 0.1714*(body_diameter_to_wingspan)^2 + 0.8326*(body_diameter_to_wingspan) + 0.9974; % function of body diameter to wingspan;
K_BW = 0.7810*(body_diameter_to_wingspan)^2 + 1.1976*(body_diameter_to_wingspan) + 0.0088; % function of body diameter to wingspan;
K_N = 2*apparent_mass_constant*S_body_max/S; % nose lift constant
