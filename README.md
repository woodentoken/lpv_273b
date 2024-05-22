# lpv_273b

This models the longitudinal dynamics of an avian inspired aircraft using approximations from [Flight Stability and Control - Nelson (1998)](https://home.engineering.iastate.edu/~shermanp/AERE355/lectures/Flight_Stability_and_Automatic_Control_N.pdf), Performance, Stability, Dynamics and Control of Airplance - Pamadi (1998), and a few references to Smetana (1994). 

# Baseline
this work assumes the wing airfoil is a [Selig4083](http://airfoiltools.com/airfoil/details?airfoil=s4083-il) and the tail airfoil is a [NACA0006](http://airfoiltools.com/airfoil/details?airfoil=naca0006-il).

# Structure
- `ac` - this is the baseline struct that houses information about the aircraft. This structure also houses the aerodynamic parameter information such as the lift alpha slope of the chosen airfoils and tail. This `ac` structure is made up of two substructures:
    - `ac.geom` - this is the geometric information about the aircraft (wing area, tail volume ratio, chord, etc.)
    - `ac.trim` - this is the trim information which is derived from the nondimensional derivatives and the desired angle of attack

Note that stability derivative information is currently not tracked within the `ac` struct. A future version will add those dimensional and nondimensional coefficients.


# Overview
The most important file is the `main.m` file, which unifies the other files and allows for tweaking of the underling model parameters and geometries. The general flow of the program is:
- use a defined geometry to fill the `ac.geom` substructure
- use prescribed aerodynamic properties, such as lift vs alpha slopes for chosen airfoils, as well as efficiency factor estimates to fill the aerodynamics of the `ac` struct
- with the `ac` aerodynamic information, and the `ac.geom` information, estimate the nondimensional stability and control derivatives via techniques found in the referenced textbooks above
- using the nodimensional derivatives, locate a flight condition in which M = 0, L = W, and D = T (trim condition).
  - this condition is saved in `ac.trim` sub structure  
- with the nondimensional derivatives and the trim condition, calculate the dimensional derivatives
- with the dimensional derivatives, fill in a state space model of the longitudinal motion of the aircraft
  - with small angle assumptions applied, etc.

# Usage
before the `nondimensional derivatives`, `dimensional derivatives` and `longitudinal_eom` scripts are run, any of the aircraft parameters can be tweaked manually to result in different dynamics, this tweaking should be done either directly in the `main.m` script, or in auxiliary scripts that can be called in `main.m` to change the aircraft dynamics

# Assumptions
- SI units are the baseline system of measurement.
- a vertical tail is not modeled and as such its drag contribution is ignored entirely
- the wing being modeled here is slightly tapered, this reduces its baseline area and slightly increases its span efficiency factor, as it is closer to an elliptical lift distribution
- as of now, fuselage effects are not being modeled
- changes to geometric properties are not reflected in changes to the moments of inertia. These must be updated separately.
  - Similarly, the center of gravity is not respondent to changes in geometry or mass. This change should be estimated as best as possible.  
- the predictions being made here are very rough, real analysis should be done with CFD or flight testing to create physically relevant information.

# Verification
This work is validated against an example provided in Nelson (1998). In that example, the nondimensional derivatives are provided along with a flight condition, and the longitudinal dynamics are recreated to be:
![image](https://github.com/woodentoken/lpv_273b/assets/43391485/21dca3ed-d019-444e-9523-770083a6c364)

This example is included in `Nelson_example.m` which can be run to produce a matching A matrix, confirming, at least, that the calculation of the dimensional derivatives from the nondimensional derivatives is valid.
