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

module profan(
    num_of_planets = 2,
    num_of_planet_gear_vents = 6,
    
    ring_gear_num_of_teeth = 96,
    planet_gear_num_of_teeth = 42
)
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
    
    // constants
    case_size = 120;
    
    motor_mount_hole_depth = 15;
    motor_mount_hole_diameter = 37.25;
    motor_mount_wall_thickness = 2.5;
    
    ring_gear_pitch_diameter = 110;
    
    case_mount_diameter = 4.3;
    
    // TODO: parametrize
    planet_gear_thickness = 2 * motor_mount_wall_thickness;
    ring_gear_thickness = 2 * motor_mount_wall_thickness;
    sun_gear_thickness = 2 * motor_mount_wall_thickness;
    
    sun_gear_axis_height = 7.5;
    
    // calculated parameters
    ring_gear_module = ring_gear_pitch_diameter / ring_gear_num_of_teeth;
    
    planet_gear_pitch_diameter = ring_gear_module * planet_gear_num_of_teeth;
    
    sun_gear_num_of_teeth = ring_gear_num_of_teeth - (2 * planet_gear_num_of_teeth);
    
    sun_gear_pitch_diameter = ring_gear_module * sun_gear_num_of_teeth;
    
    // TODO: figure better values?
    planet_gear_mount_pad_diameter = planet_gear_pitch_diameter / 2;
    planet_gear_axis_diameter = planet_gear_mount_pad_diameter / 2;
    planet_gear_axis_height = 10;
    
    // circular pitch
    sun_gear_mm_per_tooth = (PI * sun_gear_pitch_diameter) / sun_gear_num_of_teeth;
    
    sun_gear_root_diameter = root_radius(mm_per_tooth = sun_gear_mm_per_tooth, number_of_teeth = sun_gear_num_of_teeth) * 1.5;
    
    // TODO: figure better value?
    sun_gear_mount_height = sun_gear_axis_height / 4;
    
    // TODO: figure better value?
    sun_gear_axis_diameter = sun_gear_root_diameter;
    
    ring_gear_mm_per_tooth = (PI * ring_gear_pitch_diameter) / ring_gear_num_of_teeth;
    
    main_mount_diameter = motor_mount_hole_diameter + (2 * motor_mount_wall_thickness);
        
    carrier_arm_length = (sun_gear_pitch_diameter / 2) + (planet_gear_pitch_diameter / 2);
        
    carrier_arm_thickness = motor_mount_wall_thickness * 2;
    
    planet_gear_mm_per_tooth = (PI * planet_gear_pitch_diameter) / planet_gear_num_of_teeth;
    
    planet_gear_vent_diameter = (planet_gear_pitch_diameter - planet_gear_axis_diameter - (4 * motor_mount_wall_thickness)) / 2;
    
    module planet_gear()
    {
        difference()
        {
            union()
            {
                gear(
                    mm_per_tooth = planet_gear_mm_per_tooth,
                    number_of_teeth = planet_gear_num_of_teeth,
                    thickness = planet_gear_thickness,
                    hole_diameter = 0
                );
                
                translate([ 0, 0, -(planet_gear_thickness / 2) - (planet_gear_axis_height / 2) ])
                    cyl(
                        d = planet_gear_axis_diameter - (PRINTER_SLOP * 2),
                        h = planet_gear_axis_height
                    );
            }
            
            for (i = [ 1 : num_of_planet_gear_vents ])
            {
                a = (360 / num_of_planet_gear_vents) * i;
                r = (planet_gear_axis_diameter / 2) + (planet_gear_vent_diameter / 2) + motor_mount_wall_thickness;
                
                translate([ cos(a) * r, sin(a) * r, 0 ])
                    rotate([ 0, 0, a ])
                        cyl(
                            d = planet_gear_vent_diameter,
                            h = planet_gear_thickness + (2 * PRINTER_SLOP)
                        );
            }
        }
    }
    
    module sun_gear()
    {
        union()
        {
            gear(
                mm_per_tooth = sun_gear_mm_per_tooth,
                number_of_teeth = sun_gear_num_of_teeth,
                thickness = sun_gear_thickness,
                hole_diameter = 0
            );
            
            // axis
            cyl(
                d = sun_gear_axis_diameter,
                h = sun_gear_thickness + (2 * sun_gear_axis_height) - (2 * PRINTER_SLOP)
            );
            
            // mount for propeller
            // cyl(
            //     d = main_propeller_mount_diameter,
            //     h = main_propeller_mount_height
            // );
        }
    }
    
    module ring_gear()
    {
        difference()
        {
            cuboid(
                size = [ case_size, case_size, ring_gear_thickness ],
                center = true,
                edges = EDGE_BK_LF + EDGE_BK_RT + EDGE_FR_LF + EDGE_FR_RT, fillet = 5
            );
            
            gear(
                mm_per_tooth = ring_gear_mm_per_tooth,
                number_of_teeth = ring_gear_num_of_teeth,
                thickness = ring_gear_thickness + (2 * PRINTER_SLOP),
                hole_diameter = 0,
                interior = true
            );
            
            // mounting holes
            translate([ -(case_size / 2) + (case_mount_diameter), -(case_size / 2) + (case_mount_diameter), 0 ])
                cyl(
                    d = case_mount_diameter,
                    h = ring_gear_thickness + (2 * PRINTER_SLOP)
                );
            
            translate([ -(case_size / 2) + (case_mount_diameter), (case_size / 2) - (case_mount_diameter), 0 ])
                cyl(
                    d = case_mount_diameter,
                    h = ring_gear_thickness + (2 * PRINTER_SLOP)
                );
                
            translate([ (case_size / 2) - (case_mount_diameter), -(case_size / 2) + (case_mount_diameter), 0 ])
            cyl(
                d = case_mount_diameter,
                h = ring_gear_thickness + (2 * PRINTER_SLOP)
            );
        
        translate([ (case_size / 2) - (case_mount_diameter), (case_size / 2) - (case_mount_diameter), 0 ])
            cyl(
                d = case_mount_diameter,
                h = ring_gear_thickness + (2 * PRINTER_SLOP)
            );
        }
    }
    
    module carrier()
    {
        difference()
        {
            union()
            {
                // main mount
                // DEBUG
                
                if (DEBUG)
                {
                    cyl(
                        d = sun_gear_axis_diameter,
                        h = motor_mount_hole_depth + motor_mount_wall_thickness
                    );
                } else {
                    cyl(
                        d = main_mount_diameter,
                        h = motor_mount_hole_depth + motor_mount_wall_thickness
                    );
                }
                    
                // arms
                translate([ 0, 0, ((motor_mount_hole_depth + motor_mount_wall_thickness) / 2) - (carrier_arm_thickness / 2) ])
                {
                    for (i = [ 1 : num_of_planets ])
                    {
                        a = (360 / num_of_planets) * i;
                        
                        rotate([ 0, 0, a ])
                            prismoid(
                                size1 = [ main_mount_diameter, carrier_arm_thickness ],
                                size2 = [ planet_gear_mount_pad_diameter, carrier_arm_thickness ],
                                h = carrier_arm_length,
                                orient = ORIENT_X
                            );
                        
                        translate([ cos(a) * carrier_arm_length, sin(a) * carrier_arm_length, 0 ])
                        
                        cyl(
                            d = planet_gear_mount_pad_diameter,
                            h = carrier_arm_thickness
                        );
                    }
                }
                
                // sun gear holder pad
                translate([ 0, 0, ((motor_mount_hole_depth + motor_mount_wall_thickness) / 2) + (sun_gear_axis_height / 4) ])
                    difference()
                    {
                        cyl(
                            d = sun_gear_axis_diameter + (2 * motor_mount_wall_thickness),
                            h = sun_gear_axis_height / 2
                        );
                        
                        translate([ 0, 0, 0 ])
                            cyl(
                                d = sun_gear_axis_diameter,
                                h = (sun_gear_axis_height / 2) + motor_mount_wall_thickness
                            );
                    }
            }
            
            if (!DEBUG)
            {
                translate([ 0, 0, -motor_mount_wall_thickness ])
                    cyl(
                        d = motor_mount_hole_diameter,
                        h = motor_mount_hole_depth
                    );
            }
            
            for (i = [ 1 : num_of_planets ])
            {
                a = (360 / num_of_planets) * i;
                
                translate([ cos(a) * carrier_arm_length, sin(a) * carrier_arm_length, ((motor_mount_hole_depth + motor_mount_wall_thickness) / 2) - (carrier_arm_thickness / 2) ])
                    cyl(
                        d = planet_gear_axis_diameter,
                        h = planet_gear_axis_height + (PRINTER_SLOP * 2)
                    );
            }
        }
    }
    
    // assemble everything together
    ring_gear();
    
    for (i = [ 1 : num_of_planets ])
    {
        a = (360 / num_of_planets) * i;
        r = (ring_gear_pitch_diameter / 2) - (planet_gear_pitch_diameter / 2);
        
        translate([ cos(a) * r, sin(a) * r, 0 ])
            rotate([ 0, 0, 4 ])
                planet_gear();
    }
    
    rotate([ 0, 0, 15 ])
        sun_gear();
    
    translate([ 0, 0, -ring_gear_thickness - motor_mount_hole_depth - (motor_mount_wall_thickness * 2) ])
        carrier();
}

DEBUG = true;
$fn = 256;

profan(num_of_planets = 3);
