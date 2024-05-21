% 1 **model_geometry.m**
% 2 derived-quantities.m
% 3 Nelson_nd_derivatives.m
% 4 dimensional_derivatives.m
% 5 longitudinal_eom.m

%% conversion factors
inches2meters = 0.0254;

%% weight and balance
mass = 1; % kg
Iyy = 0.001042; % kg m^2
Ixx = 0;
Izz = 0;

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

%% dimensions in meters
tail_length = inches2meters * tail_length_in;
tail_width = inches2meters * tail_width_in;

half_wingspan = inches2meters * half_wingspan_in;
wingspan = wingspan_in * inches2meters;
inboard_span = inboard_span_in * inches2meters;
outboard_span = outboard_span_in * inches2meters;

body_width = body_width_in * inches2meters;
body_depth = body_width_in * inches2meters;

l_nose = nose_length_in * inches2meters;
chord = inches2meters * chord_in;

root_to_wrist = inches2meters * root_to_wrist_in;
le_to_tip = inches2meters * le_to_tip_in;
te_to_tip = inches2meters * te_to_tip_in;

wing_le_to_tail_le = wing_le_to_tail_le_in * inches2meters;

