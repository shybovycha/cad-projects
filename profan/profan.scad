include <BOSL2/shapes3d.scad>;
include <BOSL2/gears.scad>;
include <bladegen/bladegen.scad>;

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
 * The project uses BOSL2 ( https://github.com/revarbat/BOSL2 ) and bladegen ( https://github.com/tallakt/bladegen ) libraries.
 *
 * References:'
 * - https://woodgears.ca/gear/planetary.html
 * - https://www.engineersedge.com/gear_formula.htm
 */

module profan(
    num_of_planets = 2,
    num_of_planet_gear_vents = 6,
    
    num_of_propellers = 3,

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

    INCH_MM = 25.6;

    // TODO: parametrize
    planet_gear_thickness = 2 * motor_mount_wall_thickness;
    ring_gear_thickness = 10;
    sun_gear_thickness = 2 * motor_mount_wall_thickness;
    holder_thickness = 5;

    sun_gear_axis_height = 5;
    
    propeller_joint_thickness = 7.5;
    
    propeller_mount_module = 1;
    propeller_mount_thickness = 3;
    propeller_mount_num_of_teeth = 8;
    
    // calculated parameters
    ring_gear_module = ring_gear_pitch_diameter / ring_gear_num_of_teeth;

    planet_gear_pitch_diameter = ring_gear_module * planet_gear_num_of_teeth;

    sun_gear_num_of_teeth = ring_gear_num_of_teeth - (2 * planet_gear_num_of_teeth);

    sun_gear_pitch_diameter = (ring_gear_module * sun_gear_num_of_teeth);

    // TODO: figure better values?
    planet_gear_mount_pad_diameter = planet_gear_pitch_diameter / 2;
    planet_gear_axis_diameter = planet_gear_mount_pad_diameter / 2;
    planet_gear_axis_height = 10;

    // circular pitch
    sun_gear_mm_per_tooth = ((PI * (sun_gear_pitch_diameter  - (PRINTER_SLOP * 4))) / sun_gear_num_of_teeth);

    sun_gear_root_diameter = root_radius(pitch = sun_gear_mm_per_tooth, teeth = sun_gear_num_of_teeth) * 1.5;

    // TODO: figure better value?
    sun_gear_mount_height = sun_gear_axis_height / 4;

    // TODO: figure better value?
    sun_gear_axis_diameter = sun_gear_root_diameter;

    ring_gear_mm_per_tooth = (PI * (ring_gear_pitch_diameter + (PRINTER_SLOP * 4))) / ring_gear_num_of_teeth;

    main_mount_diameter = motor_mount_hole_diameter + (2 * motor_mount_wall_thickness);

    carrier_arm_length = (sun_gear_pitch_diameter / 2) + (planet_gear_pitch_diameter / 2);

    carrier_arm_thickness = motor_mount_wall_thickness * 2;

    planet_gear_mm_per_tooth = (PI * planet_gear_pitch_diameter) / planet_gear_num_of_teeth;

    planet_gear_vent_diameter = (planet_gear_pitch_diameter - planet_gear_axis_diameter - (4 * motor_mount_wall_thickness)) / 2;
    
    main_propeller_mount_diameter = sun_gear_pitch_diameter + (propeller_joint_thickness * 2);
    main_propeller_mount_thickness = (propeller_joint_thickness * 2) + (6 * motor_mount_wall_thickness);


    module planet_gear()
    {
        difference()
        {
            union()
            {
                spur_gear(
                    // mm_per_tooth = planet_gear_mm_per_tooth,
                    mod = ring_gear_module,
                    teeth = planet_gear_num_of_teeth,
                    thickness = planet_gear_thickness
                    //hole_diameter = 0
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
            spur_gear(
                // mm_per_tooth = sun_gear_mm_per_tooth,
                mod = ring_gear_module,
                teeth = sun_gear_num_of_teeth,
                thickness = sun_gear_thickness
                //hole_diameter = 0
            );

            // axis
            translate([ 0, 0, (sun_gear_thickness / 2) + (sun_gear_axis_height / 2) ])
                cyl(
                    d = sun_gear_axis_diameter,
                    h = sun_gear_axis_height - (2 * PRINTER_SLOP)
                );

            translate([ 0, 0, -((sun_gear_thickness / 2) + (sun_gear_axis_height / 2)) ])
                cyl(
                    d = sun_gear_axis_diameter,
                    h = sun_gear_axis_height - (2 * PRINTER_SLOP)
                );

            // mount for propeller
            difference()
            {
                translate([ 0, 0, (sun_gear_thickness / 2) + (main_propeller_mount_thickness / 2)])
                    cyl(
                        d1 = main_propeller_mount_diameter,
                        d2 = main_propeller_mount_diameter * 0.75,
                        h = main_propeller_mount_thickness,
                        rounding2 = 5
                    );
                
                for (i = [ 0 : num_of_propellers ])
                {
                    a = (360 / num_of_propellers) * i;
                    r = (main_propeller_mount_diameter / 2) - (propeller_mount_thickness / 2);
                    
                    translate([ cos(a) * r, sin(a) * r, (sun_gear_thickness / 2) + (main_propeller_mount_thickness / 2) ])
                        rotate([ 90, 0, 90 + a ])
                            spur_gear(mod = propeller_mount_module, teeth = propeller_mount_num_of_teeth, thickness = propeller_mount_thickness + (PRINTER_SLOP * 2));
                }
            }
        }
    }

    module ring_gear()
    {
        difference()
        {
            cuboid(
                size = [ case_size, case_size, ring_gear_thickness ],
                anchor = CENTER,
                edges = [FWD + LEFT, BACK + LEFT, FWD + RIGHT, BACK + RIGHT],
                rounding = 5
            );

            spur_gear(
                mod = ring_gear_module,
                // mm_per_tooth = ring_gear_mm_per_tooth,
                teeth = ring_gear_num_of_teeth,
                thickness = ring_gear_thickness + (2 * PRINTER_SLOP),
                //hole_diameter = 0,
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

                        rotate([ 90, 0, a ])
                            prismoid(
                                size1 = [ main_mount_diameter, carrier_arm_thickness ],
                                size2 = [ planet_gear_mount_pad_diameter, carrier_arm_thickness ],
                                h = carrier_arm_length,
                                orient = RIGHT
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

    module top_holder()
    {
        difference()
        {
            union()
            {
                for (i = [ 0 : 4 ])
                {
                    a = 45 + (90 * i);
                    r = sqrt(pow(case_size / 2, 2) + pow(case_size / 2, 2)) - (case_mount_diameter + (motor_mount_wall_thickness * 3)) / 2;

                    difference()
                    {
                        union()
                        {
                            // arm
                            translate([ cos(a) * (r / 2), sin(a) * (r / 2), 0 ])
                                rotate([ 0, 0, a ])
                                    cuboid(
                                        size = [ r, sun_gear_axis_diameter + (motor_mount_wall_thickness * 2), holder_thickness ],
                                        anchor = CENTER
                                    );

                            // mounting hole
                            translate([ cos(a) * r, sin(a) * r, 0 ])
                                cyl(
                                    d = sun_gear_axis_diameter + (motor_mount_wall_thickness * 2),
                                    h = holder_thickness,
                                    anchor = CENTER
                                );
                        }

                        translate([ cos(a) * r, sin(a) * r, 0 ])
                            cyl(
                                d = case_mount_diameter + (PRINTER_SLOP * 2),
                                h = holder_thickness + (PRINTER_SLOP * 2),
                                anchor = CENTER
                            );
                    }
                }

                // stopper for planet gears
                difference()
                {
                    cyl(
                        d = (sun_gear_pitch_diameter + planet_gear_pitch_diameter + planet_gear_axis_diameter) + holder_thickness,
                        h = holder_thickness
                    );

                    cyl(
                        d = (sun_gear_pitch_diameter + planet_gear_pitch_diameter - planet_gear_axis_diameter - motor_mount_wall_thickness),
                        h = holder_thickness + (PRINTER_SLOP * 2)
                    );
                }
            }

            // translate([ 0, 0, -(sun_gear_axis_height / 2) ])
                cyl(
                    d = sun_gear_axis_diameter,
                    h = sun_gear_axis_height * 2
                );
        }
    }

    module bottom_holder()
    {
        difference()
        {
            union()
            {
                for (i = [ 0 : 4 ])
                {
                    a = 45 + (90 * i);
                    r = sqrt(pow(case_size / 2, 2) + pow(case_size / 2, 2)) - (case_mount_diameter + (motor_mount_wall_thickness * 3)) / 2;

                    difference()
                    {
                        union()
                        {
                            // arm
                            translate([ cos(a) * (r / 2), sin(a) * (r / 2), 0 ])
                                rotate([ 0, 0, a ])
                                    cuboid(
                                        size = [ r, sun_gear_axis_diameter + (motor_mount_wall_thickness * 2), holder_thickness ],
                                        anchor = CENTER
                                    );

                            // mounting hole
                            translate([ cos(a) * r, sin(a) * r, 0 ])
                                cyl(
                                    d = sun_gear_axis_diameter + (motor_mount_wall_thickness * 2),
                                    h = holder_thickness,
                                    anchor = CENTER
                                );
                        }

                        translate([ cos(a) * r, sin(a) * r, 0 ])
                            cyl(
                                d = case_mount_diameter + (PRINTER_SLOP * 2),
                                h = holder_thickness + (PRINTER_SLOP * 2),
                                anchor = CENTER
                            );
                    }
                    
                    cyl(
                        d = motor_mount_hole_diameter + (6 * motor_mount_wall_thickness),
                        h = holder_thickness
                    );
                }
            }
            
            if (!DEBUG)
            {
                cyl(
                    d = motor_mount_hole_diameter + (PRINTER_SLOP * 2),
                    h = holder_thickness + (PRINTER_SLOP * 2)
                );
            } else {
                cyl(
                    d = sun_gear_axis_diameter,
                    h = holder_thickness + (PRINTER_SLOP * 2)
                );
            }
        }
    }
    
    module propeller()
    {
        // propeller blades
        // translate([0, 0, 0])   bladegen(pitch = 4 * INCH_MM, diameter = 5 * INCH_MM);
        // translate([0, 25, 0])  bladegen(pitch = 4 * INCH_MM, diameter = 5 * INCH_MM, outline = rectangular_outline());
        // translate([0, 50, 0])  bladegen(pitch = 4 * INCH_MM, diameter = 5 * INCH_MM, outline = rectangular_outline(taper_tip = 0.5));
        // translate([0, 75, 0])  bladegen(pitch = 4 * INCH_MM, diameter = 5 * INCH_MM, outline = elliptical_outline(exponent = 5));
        
        // spur_gear(mod = propeller_mount_module, teeth = propeller_mount_num_of_teeth, thickness = propeller_mount_thickness);
    }

    // assemble everything together

    if (!DEBUG)
    {
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

        translate([ 0, 0, ring_gear_thickness + (PRINTER_SLOP * 4) ])
            top_holder();
    } else {
        if (HAS_RING)
        {
            ring_gear();
        }

        if (HAS_PLANETS)
        {
            for (i = [ 0 : num_of_planets - 1 ])
            {
                translate([ planet_gear_pitch_diameter * 1.2 * (i - 1), ring_gear_pitch_diameter * 0.85, 0 ])
                    rotate([ 180, 0, 0 ])
                        planet_gear();
            }
        }

        if (HAS_SUN)
        {
            // translate([ ring_gear_pitch_diameter / 5, -ring_gear_pitch_diameter / 3.5, sun_gear_axis_height ])
                sun_gear();
        }

        if (HAS_CARRIER)
        {
            translate([ 0, 0, ring_gear_thickness + sun_gear_mount_height + (motor_mount_wall_thickness * 1.5) ])
                rotate([ 180, 0, 0 ])
                    carrier();
        }

        if (HAS_TOP_HOLDER)
        {
            translate([ 0, 0, 50 ])
                top_holder();
        }

        if (HAS_BOTTOM_HOLDER)
        {
            translate([ 0, 0, -(motor_mount_hole_depth + ring_gear_thickness + holder_thickness) ])
                bottom_holder();
        }
    }
}

HAS_RING = false;
HAS_PLANETS = false;
HAS_SUN = true;
HAS_CARRIER = false;
HAS_TOP_HOLDER = false;
HAS_BOTTOM_HOLDER = false;

DEBUG = true;

$slop = 0.15;
PRINTER_SLOP = $slop;
$fn = 64;

profan(num_of_planets = 3, num_of_propellers = 3);
