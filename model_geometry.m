%% conversion factors
inches2meters = 0.0254;


%% dimensions in inches
tail_length_in = 10.20;

half_wingspan_in = 23;

body_width_in = 4.4;
body_depth_in = 3.5;

chord_in = 10.70;

root_to_wrist_in = 7;
le_to_tip_in = 15.5;
te_to_tip_in = 17;

%% dimensions in meters
tail_length = inches2meters * tail_length_in;
half_wingspan = inches2meters * half_wingspan_in;

chord = inches2meters * chord_in;

root_to_wrist = inches2meters * root_to_wrist_in;
le_to_tip = inches2meters * le_to_tip_in;
te_to_tip = inches2meters * te_to_tip_in;

%% derived calculations (areas, etc.)
root_to_wrist_area = root_to_wrist * chord;

semiperimeter = (te_to_tip + le_to_tip + chord)/2;
wrist_to_tip_area = sqrt( ...
    semiperimeter* ...
    ((semiperimeter-te_to_tip)* ...
    (semiperimeter-le_to_tip)* ...
    (semiperimeter-chord)) ...
    );


half_wing_area = wrist_to_tip_area + root_to_wrist_area;

wing_area = 2 * half_wing_area;

S_wing = wing_area;
