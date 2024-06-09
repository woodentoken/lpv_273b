function ac = fill_model_geometry(ac)
% 1 **model_geometry.m**
% **1 model_geometry.m**
% 2 derived-quantities.m
% 3 Nelson_nd_derivatives.m
% 4 dimensional_derivatives.m
% 5 longitudinal_eom.m

%% conversion factors
inches2meters = 0.0254;


%% weight and balance
ac.mass = 1; % kg
ac.Iyy = 0.1042; % kg m^2
ac.Ixx = 0;
ac.Izz = 0;

%% dimensions in inches
tail_length_in = 10.20;
tail_width_in = 2; % initial, furled tail width

half_wingspan_in = 23;
height_tail = 0; % assumed
wingspan_in = 50;
inboard_span_in = 7;
outboard_span_in = 15.25;

body_width_in = 4.4;
body_depth_in = 3.5;

nose_length_in = 4.2;
chord_in = 10.70;

root_to_wrist_in = 7;
le_to_tip_in = 15.5;
te_to_tip_in = 17;

wing_le_to_tail_le_in = chord_in;
wing_le_to_tail_le = wing_le_to_tail_le_in * inches2meters;

%% dimensions in meters
chord = inches2meters * chord_in;

l_nose = nose_length_in * inches2meters;
tail_length = inches2meters * tail_length_in;
tail_width = inches2meters * tail_width_in;

body_width = body_width_in * inches2meters;
body_depth = body_width_in * inches2meters;

% lengths
l_tail = 3*wing_le_to_tail_le + 0.25*tail_length; % tail moment arm (le of wing to ac of tail)
l_fuselage = l_nose + chord;
body_fineness_ratio = l_fuselage/body_width;

half_wingspan = inches2meters * half_wingspan_in;
wingspan = wingspan_in * inches2meters;
inboard_span = inboard_span_in * inches2meters;
outboard_span = outboard_span_in * inches2meters;

root_to_wrist = inches2meters * root_to_wrist_in;
le_to_tip = inches2meters * le_to_tip_in;
te_to_tip = inches2meters * te_to_tip_in;

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
S_tail_spread = pi*tail_length^2*(spread_angle/360); % segment of a circle
S_tail_furled = 1.1*tail_length * tail_width;
S_tail = S_tail_spread;

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

%% fill ac structure with relevant measurements;
ac.geom.S = wing_area;
ac.geom.b_wing = b_wing;
ac.geom.c_bar = mean_chord_exposed_wing;
ac.geom.AR = AR_exposed;

ac.geom.S_tail = S_tail;
ac.geom.S_tail_furled = S_tail_furled;
ac.geom.S_tail_spread = S_tail_spread;
ac.geom.b_tail_spread = b_tail_spread;
ac.geom.b_tail_furled = b_tail_furled;
ac.geom.AR_tail = AR_tail;
ac.geom.AR_tail_furled = AR_tail_furled;
ac.geom.V_tail = V_tail;
ac.geom.l_tail = l_tail;

ac.geom.S_body_max = S_body_max;
ac.geom.body_ratio = body_diameter_to_wingspan;

end


