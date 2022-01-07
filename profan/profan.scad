include <BOSL/shapes.scad>;
include <BOSL/involute_gears.scad>;

/*
 * ProFan
 *
 * This is the fan project for the fan rundown by MajorHardware.
 *
 * The name is ProFan comes from these few facts:
 *   a. this project uses propellers
 *   b. i am a total profan in aerodynamics, hardware engineering and CAD modelling
 *
 * The idea is to use airplane-like propellers and utilize planetary gears to spin the main propeller as fast as possible for the best performance.
 *
 *
 * References:
 * - https://woodgears.ca/gear/planetary.html
 * - https://www.engineersedge.com/gear_formula.htm
 */

module profan()
{
    // critical dimensions:
    //   1. max outer diameter = 110 mm
    //   2. motor mount hole depth = 15 mm
    //   3. motor mount hole diameter = 37.25 mm
    
    // planetary gears calculation:
    //   1. planets = 2 or 3
    //   2.
    //     a. ring teeth = 72
    //     b. planet teeth = 30
    //     c. sun teeth = 12
    //   3.
    //     a. carrier speed = 20 RPM
    //     b. ring - static
    //   4. sun speed = 140 RPM (7x speed up)
    
    // ring gear:
    //   number of teeth (N)
    //   pitch diameter (D)
    //   circular pitch (p) = (PI * D) / N
    //   diametral pitch (P) = N / D = PI / p
    //

    // tooth number equation:
    //   R = 2 * P + S
    //
    // turn ratio:
    //   (R + S) * T_c = R * T_r + T_s * S
    //
    // where
    //   R - number of ring gear teeth
    //   S - number of sun gear teeth
    //   T_c - turns of carrier
    //   T_r - turns of ring
    //   T_s - turns of sun
    
    // hence
    //   (R + S) * T_c = R * 0 + T_s * S 
    //     => (R + S) * T_c = T_s * S
    //     => T_s = (R + S) * T_c / S
    //   assume T_c = 1
    //     T_s = (R + S) / S
    //
    // let R = 96 and S = 12, then P = 42 => T_s = 9, meaning 1 turn of carrier will result in 9 turns of sun gear
    
    // gear module = D / N
    
    // IMPORTANT: all gears' modules must be equal
    
    ring_gear_pitch_diameter = 110;
    
    // TODO: parametrize
    ring_gear_num_of_teeth = 96;
    planet_gear_num_of_teeth = 42;
    
    planet_gear_thickness = 10;
    ring_gear_thickness = 10;
    sun_gear_thickness = 10;
    
    // calculated parameters
    ring_gear_module = ring_gear_pitch_diameter / ring_gear_num_of_teeth;
    
    planet_gear_pitch_diameter = ring_gear_module * planet_gear_num_of_teeth;
    
    sun_gear_num_of_teeth = ring_gear_num_of_teeth - (2 * planet_gear_num_of_teeth);
    
    sun_gear_pitch_diameter = ring_gear_module * sun_gear_num_of_teeth;
    
    module planet_gear()
    {
        // circular pitch
        mm_per_tooth = (PI * planet_gear_pitch_diameter) / planet_gear_num_of_teeth;
        
        gear(
            mm_per_tooth = mm_per_tooth,
            number_of_teeth = planet_gear_num_of_teeth,
            thickness = planet_gear_thickness,
            hole_diameter = 0
        );
    }
    
    module sun_gear()
    {
        // circular pitch
        mm_per_tooth = (PI * sun_gear_pitch_diameter) / sun_gear_num_of_teeth;
        
        gear(
            mm_per_tooth = mm_per_tooth,
            number_of_teeth = sun_gear_num_of_teeth,
            thickness = sun_gear_thickness,
            hole_diameter = 0
        );
    }
    
    module ring_gear()
    {
        // circular pitch
        mm_per_tooth = (PI * ring_gear_pitch_diameter) / ring_gear_num_of_teeth;
        
        difference()
        {
            // TODO: this should be cuboid to allow for mounting holes on top of a fan case
            cyl(
                d = ring_gear_pitch_diameter + ring_gear_thickness,
                h = ring_gear_thickness
            );
            
            gear(
                mm_per_tooth = mm_per_tooth,
                number_of_teeth = ring_gear_num_of_teeth,
                thickness = ring_gear_thickness + (2 * PRINTER_SLOP),
                hole_diameter = 0,
                interior = true
            );
        }
    }
    
    ring_gear();
    
    translate([ -(ring_gear_pitch_diameter / 2) + (planet_gear_pitch_diameter / 2), 0, 0 ])
        rotate([ 0, 0, 4 ])
            planet_gear();
    
    translate([ (ring_gear_pitch_diameter / 2) - (planet_gear_pitch_diameter / 2), 0, 0 ])
        rotate([ 0, 0, 4 ])
            planet_gear();
    
    rotate([ 0, 0, 15 ])
        sun_gear();
}

$fn = 128;

profan();
