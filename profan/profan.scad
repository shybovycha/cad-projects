include <BOSL2/std.scad>;
include <BOSL2/shapes3d.scad>;
include <BOSL2/gears.scad>;
include <BOSL2/walls.scad>;
include <BOSL2/drawing.scad>;
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
    num_of_planet_gear_vents = 4,
    
    num_of_propellers = 3,

    ring_gear_num_of_teeth = 96,
    planet_gear_num_of_teeth = 42,
    
    case_size = 120,

    motor_mount_hole_depth = 15,
    motor_mount_hole_diameter = 37.25,
    motor_mount_wall_thickness = 2.5,

    ring_gear_pitch_diameter = 110,

    case_mount_diameter = 4.3,
    
    helical = 0
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
    INCH_MM = 25.6;

    // TODO: parametrize
    planet_gear_thickness = 2 * motor_mount_wall_thickness;
    ring_gear_thickness = 10;
    sun_gear_thickness = 2 * motor_mount_wall_thickness;
    holder_thickness = 5;
    
    min_propeller_mount_diameter = 22;

    sun_gear_axis_height = 5;
    
    propeller_joint_thickness = 7.5;
    
    propeller_mount_module = 1;
    propeller_mount_thickness = 3;
    propeller_mount_num_of_teeth = 8;
    
    propeller_blade_pitch = 42 * INCH_MM; // the more the pitch - the more flat the blade; try 8 inch and 12 inch values
    propeller_blade_pad_radius = 0.25 * INCH_MM;
    
    // calculated parameters
    ring_gear_module = ring_gear_pitch_diameter / ring_gear_num_of_teeth;

    planet_gear_pitch_diameter = ring_gear_module * planet_gear_num_of_teeth;

    sun_gear_num_of_teeth = ring_gear_num_of_teeth - (2 * planet_gear_num_of_teeth);

    sun_gear_pitch_diameter = (ring_gear_module * sun_gear_num_of_teeth);

    // according to ball bearing outer diameter
    planet_gear_mount_pad_inner_diameter = 11 + (PRINTER_SLOP * 2);
    
    planet_gear_mount_pad_diameter = planet_gear_mount_pad_inner_diameter + (motor_mount_wall_thickness * 2);
    
    planet_gear_mount_pad_thickness = 3 + (PRINTER_SLOP * 2);
    
    // according to the ball bearing inner diameter
    planet_gear_axis_diameter = 7 + PRINTER_SLOP;
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

    planet_gear_vent_diameter = (planet_gear_pitch_diameter - planet_gear_axis_diameter - (num_of_planet_gear_vents * motor_mount_wall_thickness )) / 2;
    
    planet_gear_outer_diameter = outer_radius(pitch = sun_gear_mm_per_tooth, teeth = planet_gear_num_of_teeth) * 2;
    
    planet_gear_root_diameter = root_radius(pitch = sun_gear_mm_per_tooth, teeth = planet_gear_num_of_teeth) * 2;
    
    main_propeller_mount_diameter = min(sun_gear_pitch_diameter + (propeller_joint_thickness * 2), min_propeller_mount_diameter);
    main_propeller_mount_thickness = (propeller_joint_thickness * 2) + (2 * motor_mount_wall_thickness);
    
    ring_gear_brim_width = (adendum(mod = ring_gear_module) + dedendum(mod = ring_gear_module)) * 2;
    
    main_propeller_mount_diameter_base = main_propeller_mount_diameter;
    
    main_propeller_mount_diameter_top = main_propeller_mount_diameter * 0.75;
    
    propeller_mount_groove_offset_z = 0.9;
    propeller_mount_groove_radius = lerp(main_propeller_mount_diameter_base, main_propeller_mount_diameter_top, 1 - propeller_mount_groove_offset_z) / 2;

    module planet_gear()
    {
        difference()
        {
            union()
            {
                spur_gear(
                    mod = ring_gear_module - (PRINTER_SLOP / 6),
                    teeth = planet_gear_num_of_teeth,
                    thickness = planet_gear_thickness,
                    helical = helical
                );

                translate([ 0, 0, -(planet_gear_thickness / 2) - (planet_gear_axis_height / 2) ])
                    cyl(
                        d = planet_gear_axis_diameter,
                        h = planet_gear_axis_height
                    );
            }

            // vents
            difference()
            {
                cyl(
                    r = (planet_gear_root_diameter / 2) - motor_mount_wall_thickness,
                    h = planet_gear_axis_height
                );
                
                for (i = [ 1 : num_of_planet_gear_vents ])
                {
                    a = (360 / num_of_planet_gear_vents) * i;
                    
                    w = (planet_gear_root_diameter / 2);
                    
                    r = (planet_gear_root_diameter / 2) - (w / 2) + (planet_gear_axis_diameter / 2);
                    
                    translate([ cos(a) * r, sin(a) * r, 0 ])
                        rotate([ 0, 0, a ])
                            cuboid(
                                size = [ w, motor_mount_wall_thickness * 1.25, planet_gear_axis_height + PRINTER_SLOP ]
                            );
                }
                
                cyl(
                    r = planet_gear_axis_diameter,
                    h = planet_gear_axis_height + PRINTER_SLOP
                );
            }
            
            /*for (i = [ 1 : num_of_planet_gear_vents ])
            {
                a = (360 / num_of_planet_gear_vents) * i;
                b = (360 / num_of_planet_gear_vents) * (i - 1);
                
                r = (planet_gear_root_diameter / 2) - (motor_mount_wall_thickness / 3) - (planet_gear_vent_diameter / 2);

                translate([ cos(a) * r, sin(a) * r, 0 ])
                    // rotate([ 0, 0, a ])
                        difference()
                        {
                            arc(r = 1.5 * r, angle = [ b, a ], wedge = true);
                            
                            cyl(r = 0.5 * r, h = planet_gear_axis_height);
                        }
            }*/
        }
    }

    module sun_gear()
    {
        union()
        {
            spur_gear(
                mod = ring_gear_module,
                teeth = sun_gear_num_of_teeth,
                thickness = sun_gear_thickness + motor_mount_wall_thickness + (PRINTER_SLOP * 2),
                helical = helical
            );

            // axis
            translate([ 0, 0, -(((sun_gear_thickness + motor_mount_wall_thickness) / 2) + (carrier_arm_thickness / 2)) ])
                cyl(
                    d = planet_gear_axis_diameter,
                    h = carrier_arm_thickness + PRINTER_SLOP //sun_gear_axis_height + (2 * PRINTER_SLOP)
                );

            // brim
            /*translate([ 0, 0, -((sun_gear_thickness / 2) + (sun_gear_axis_height / 2) - (motor_mount_wall_thickness / 4)) ])
                cyl(
                    d = (root_radius(mod = ring_gear_module,
                teeth = sun_gear_num_of_teeth) * 2) + (root_radius(mod = ring_gear_module - (PRINTER_SLOP / 6), teeth = planet_gear_num_of_teeth)),
                    h = (motor_mount_wall_thickness / 2) // - (2 * PRINTER_SLOP)
                );*/
                
            translate([ 0, 0, (sun_gear_thickness / 2) + (motor_mount_wall_thickness / 2) ])
                cyl(
                    d = (root_radius(mod = ring_gear_module,
                teeth = sun_gear_num_of_teeth) * 2) + (root_radius(mod = ring_gear_module - (PRINTER_SLOP / 6), teeth = planet_gear_num_of_teeth)), // main_propeller_mount_diameter_base,
                    h = motor_mount_wall_thickness / 2
                );

            // mount for propeller
            difference()
            {
                translate([ 0, 0, (sun_gear_thickness / 2) + (main_propeller_mount_thickness / 2) - (motor_mount_wall_thickness / 2) ])
                    cyl(
                        d = main_propeller_mount_diameter_top,
                        h = main_propeller_mount_thickness - motor_mount_wall_thickness,
                        rounding2 = 8
                    );
                
                for (i = [ 0 : num_of_propellers ])
                {
                    a = (360 / num_of_propellers) * i;
                    r = (main_propeller_mount_diameter / 2) - (propeller_mount_thickness) - (PRINTER_SLOP * 4);
                    
                    translate([ cos(a) * r, sin(a) * r, (sun_gear_thickness / 2) + (main_propeller_mount_thickness / 2) ])
                        rotate([ 90, 0, 90 + a ])
                            cyl(
                                r = outer_radius(
                                    mod = propeller_mount_module + (PRINTER_SLOP / 2),
                                    teeth = propeller_mount_num_of_teeth
                                ),
                                h = (propeller_mount_thickness * 5)
                            );
                            /*spur_gear(
                                mod = propeller_mount_module + (PRINTER_SLOP / 2), 
                                teeth = propeller_mount_num_of_teeth,
                                thickness = (propeller_mount_thickness * 4),
                                clearance = -PRINTER_SLOP * 2
                            );*/
                    
                    /*translate([ cos(a) * (r + (propeller_mount_thickness / 2)), sin(a) * (r + (propeller_mount_thickness / 2)), (sun_gear_thickness / 2) + (main_propeller_mount_thickness / 2) ])
                        rotate([ 90, 0, 90 + a ])
                            cyl(
                                r = propeller_blade_pad_radius,
                                h = (propeller_mount_thickness * 2) + (PRINTER_SLOP * 4)
                            );*/
                }
                
                // groove
                // translate([ 0, 0, (sun_gear_thickness / 2) + (main_propeller_mount_thickness * (1 - propeller_mount_groove_offset_z)) ])
                /*translate([ 0, 0, (sun_gear_thickness / 2) ])
                    torus(
                        r_maj = propeller_mount_groove_radius,
                        r_min = (motor_mount_wall_thickness / 2) + (2 * PRINTER_SLOP)
                    );*/
            }
            
            /*translate([ 0, 0, (sun_gear_thickness * 1.5) + main_propeller_mount_thickness - motor_mount_wall_thickness * 2 ])
            cyl(
                l = (2 * motor_mount_wall_thickness),
                d1 = main_propeller_mount_diameter_top,
                d2 = 0.5
            );*/
        }
    }

    module ring_gear()
    {
        union()
        {
            difference()
            {
                translate([ 0, 0, -(motor_mount_wall_thickness * 2) ])
                    cuboid(
                        size = [ case_size, case_size, ring_gear_thickness + (motor_mount_wall_thickness * 4) ],
                        anchor = CENTER,
                        edges = [FWD + LEFT, BACK + LEFT, FWD + RIGHT, BACK + RIGHT],
                        rounding = 5
                    );

                translate([ 0, 0, -(motor_mount_wall_thickness * 2) ])
                    spur_gear(
                        mod = ring_gear_module,
                        teeth = ring_gear_num_of_teeth,
                        thickness = ring_gear_thickness + (4 * motor_mount_wall_thickness) + (PRINTER_SLOP),
                        interior = true,
                        helical = helical
                    );

                // mounting holes
                translate([ -(case_size / 2) + (case_mount_diameter), -(case_size / 2) + (case_mount_diameter), 0 ])
                    cyl(
                        d = case_mount_diameter,
                        h = (ring_gear_thickness * 2) + (4 * motor_mount_wall_thickness) + (2 * PRINTER_SLOP)
                    );

                translate([ -(case_size / 2) + (case_mount_diameter), (case_size / 2) - (case_mount_diameter), 0 ])
                    cyl(
                        d = case_mount_diameter,
                        h = (ring_gear_thickness * 2) + (4 * motor_mount_wall_thickness) + (2 * PRINTER_SLOP)
                    );

                translate([ (case_size / 2) - (case_mount_diameter), -(case_size / 2) + (case_mount_diameter), 0 ])
                cyl(
                    d = case_mount_diameter,
                    h = (ring_gear_thickness * 2) + (4 * motor_mount_wall_thickness) + (2 * PRINTER_SLOP)
                );

            translate([ (case_size / 2) - (case_mount_diameter), (case_size / 2) - (case_mount_diameter), 0 ])
                cyl(
                    d = case_mount_diameter,
                    h = (ring_gear_thickness * 2) + (4 * motor_mount_wall_thickness) + (2 * PRINTER_SLOP)
                );
            }
            
            // brim
            difference()
            {
                translate([ 0, 0, (ring_gear_thickness / 2) - (motor_mount_wall_thickness) ])
                    cyl(
                        d = outer_radius(mod = ring_gear_module, teeth = ring_gear_num_of_teeth, interior = true) * 2,
                        h = motor_mount_wall_thickness * 2,
                        anchor = CENTER
                    );
                
                translate([ 0, 0, (ring_gear_thickness / 2) - (motor_mount_wall_thickness) ])
                    cyl(
                        r = root_radius(mod = ring_gear_module, teeth = ring_gear_num_of_teeth, interior = true) - ring_gear_brim_width,
                        h = motor_mount_wall_thickness * 2 + (2 * PRINTER_SLOP),
                        anchor = CENTER
                    );
            }
            
            // propeller mount support
            /*difference()
            {
                union()
                {
                    for (i = [ 0 : 4 ])
                    {
                        a = 45 + (90 * i);
                        r = sqrt(pow(case_size / 2, 2) + pow(case_size / 2, 2)) - (case_mount_diameter + (motor_mount_wall_thickness * 3)) / 2 - case_mount_diameter;

                        // arm
                        translate([ cos(a) * (r / 2), sin(a) * (r / 2), (ring_gear_thickness / 2) - (motor_mount_wall_thickness / 2) ])
                            rotate([ 0, 0, a ])
                                // TODO: does not work in BOSL2
                                //sparse_strut(
                                    //h = motor_mount_wall_thickness,
                                    //l = sun_gear_axis_diameter + (motor_mount_wall_thickness * 2),
                                    //thick = motor_mount_wall_thickness,
                                    //anchor = CENTER
                                //);
                        
                                cuboid(
                                    size = [ r, sun_gear_axis_diameter, motor_mount_wall_thickness ],
                                    anchor = CENTER
                                );
                    }
                    
                    
                    translate([ 0, 0, (ring_gear_thickness / 2) - (motor_mount_wall_thickness / 2) ])
                        cyl(
                            d = (main_propeller_mount_diameter * 0.95) + (sun_gear_axis_diameter + (motor_mount_wall_thickness * 2)),
                            h = motor_mount_wall_thickness
                        );
                }
            
                translate([ 0, 0, (ring_gear_thickness / 2) - (motor_mount_wall_thickness / 2) ])
                    cyl(
                        d = main_propeller_mount_diameter_top + (8 * PRINTER_SLOP),
                        h = motor_mount_wall_thickness + (2 * PRINTER_SLOP)
                    );
            }*/
            
            // propeller mount latch
            /*for (i = [ 0 : num_of_planets ])
            {
                a = ((360 / num_of_planets) * i);
                r = (main_propeller_mount_diameter * 0.95 / 2);
                
                translate([ cos(a) * r, sin(a) * r, (ring_gear_thickness / 2) - (motor_mount_wall_thickness / 2) ])
                    sphere(
                        r = motor_mount_wall_thickness / 2.5
                    );
            }*/
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
                        d = min(sun_gear_axis_diameter, 8),
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

                        difference()
                        {
                            rotate([ 90, 0, a ])
                                prismoid(
                                    size1 = [ main_mount_diameter, carrier_arm_thickness ],
                                    size2 = [ planet_gear_mount_pad_diameter, carrier_arm_thickness ],
                                    h = carrier_arm_length,
                                    orient = RIGHT
                                );
                            
                            r3 = (2 * motor_mount_wall_thickness);
                            
                            translate([ cos(a) * r3, sin(a) * r3, 0 ])
                                rotate([ 90, 0, a ])
                                    scale([ 0.75, 2, 0.75 ])
                                    prismoid(
                                        size1 = [ main_mount_diameter, carrier_arm_thickness ],
                                        size2 = [ planet_gear_mount_pad_diameter, carrier_arm_thickness ],
                                        h = carrier_arm_length,
                                        orient = RIGHT
                                    );
                        }
                        
                        /*rotate([ 0, 90, a ])
                        translate([ 0, 0, -planet_gear_mount_pad_diameter / 2 ])
                        sparse_strut(
                            h = planet_gear_mount_pad_diameter,
                            l = carrier_arm_length,
                            thick = carrier_arm_thickness,
                            anchor = BOTTOM + BACK,
                            strut = 1
                            //orient = UP
                        );*/

                        translate([ cos(a) * carrier_arm_length, sin(a) * carrier_arm_length, motor_mount_wall_thickness / 2 ])
                            cyl(
                                d = planet_gear_mount_pad_diameter,
                                h = carrier_arm_thickness + motor_mount_wall_thickness
                            );

                    }
                }
                
                translate([ 0, 0, carrier_arm_thickness + motor_mount_wall_thickness ])
                    cyl(
                        d = planet_gear_mount_pad_diameter,
                        h = carrier_arm_thickness + motor_mount_wall_thickness
                    );
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

                translate([ cos(a) * carrier_arm_length, sin(a) * carrier_arm_length, carrier_arm_thickness + motor_mount_wall_thickness * 3 ])
                {
                    cyl(
                        d = planet_gear_mount_pad_inner_diameter,
                        h = carrier_arm_thickness + motor_mount_wall_thickness + PRINTER_SLOP
                    );
                }
                
                translate([ cos(a) * carrier_arm_length, sin(a) * carrier_arm_length, (carrier_arm_thickness / 2) + (motor_mount_wall_thickness / 2) + motor_mount_wall_thickness ])
                    cyl(
                        d = planet_gear_axis_diameter + (4 * PRINTER_SLOP),
                        h = motor_mount_wall_thickness * 2 + (2 * PRINTER_SLOP)
                    );
                
                /*translate([ cos(a) * (carrier_arm_length / 3), sin(a) * (carrier_arm_length / 3), 6 ])
                    rotate([ 90, 0, a ])
                        prismoid(
                            size1 = [ main_mount_diameter - (8 * motor_mount_wall_thickness), carrier_arm_thickness * 2 ],
                            size2 = [ planet_gear_mount_pad_diameter - (1 * motor_mount_wall_thickness), carrier_arm_thickness * 2 ],
                            h = carrier_arm_length / 3,
                            orient = RIGHT
                        );*/
            }
            
            translate([ 0, 0, carrier_arm_thickness + (motor_mount_wall_thickness * 2) + PRINTER_SLOP ])
                cyl(
                    d = planet_gear_mount_pad_inner_diameter,
                    h = carrier_arm_thickness // + motor_mount_wall_thickness
                );
        }
    }
    
    module propeller()
    {
        union()
        {
            // propeller blades
            translate([ propeller_mount_thickness, 0, propeller_blade_pad_radius / 2 ])
                // "just don't"
                // bladegen(pitch = propeller_blade_pitch, diameter = ring_gear_pitch_diameter);
            
                // "square"
                // bladegen(pitch = propeller_blade_pitch, diameter = ring_gear_pitch_diameter, outline = rectangular_outline());
            
                // "sharp"
                bladegen(pitch = propeller_blade_pitch, diameter = ring_gear_pitch_diameter, outline = rectangular_outline(taper_tip = 0.5));
            
                // "butterknife"
                // bladegen(pitch = propeller_blade_pitch, diameter = ring_gear_pitch_diameter, outline = elliptical_outline(exponent = 5));
            
            translate([ -(propeller_mount_thickness / 2) + 1.4, 0, 0 ])
                rotate([ 0, 90, 0 ])
                    cyl(
                        r = outer_radius(
                            mod = propeller_mount_module,
                            teeth = propeller_mount_num_of_teeth
                        ) + 0.3,
                        h = (propeller_mount_thickness * 3.5) - 2.8
                    );
            
                    /*spur_gear(
                        mod = propeller_mount_module,
                        backlash = (PRINTER_SLOP * 2),
                        teeth = propeller_mount_num_of_teeth,
                        thickness = (propeller_mount_thickness * 2) // - PRINTER_SLOP
                    );*/
            
            // concave for better fit to mount
            difference()
            {
                translate([ propeller_mount_thickness, 0, 0 ])
                scale([ 1, 1, 1 ])
                    rotate([ 0, 90, 0 ])
                        cyl(
                            r = propeller_blade_pad_radius,
                            h = propeller_mount_thickness / 2
                        );
                
                /*translate([ -((propeller_mount_thickness * 2) + (propeller_mount_thickness / 2)), 0, 0 ])
                    cyl(
                        d = main_propeller_mount_diameter_top,
                        h = main_propeller_mount_thickness
                    );*/
            }
        }
    }

    // assemble everything together

    if (ASSEMBLY)
    {
        ring_gear();

        for (i = [ 1 : num_of_planets ])
        {
            a = (360 / num_of_planets) * i;
            r = (ring_gear_pitch_diameter / 2) - (planet_gear_pitch_diameter / 2);

            color([ 0.2, 0.7, 0.2 ])
            translate([ cos(a) * r, sin(a) * r, 0 ])
                rotate([ 0, 0, 4 ])
                    planet_gear();
        }
        
        for (i = [ 1 : num_of_propellers ])
        {
            a = (360 / num_of_propellers) * i;
            r = (main_propeller_mount_diameter_top / 2);

            color([ 0.7, 0.7, 0.2 ])
            translate([ cos(a) * r, sin(a) * r, (main_propeller_mount_thickness / 2) ])
                rotate([ -36, 0, a ])
                    propeller();
        }

        color([ 0.7, 0.2, 0.7 ])
        translate([ 0, 0, -motor_mount_wall_thickness ])
            sun_gear();

        color([ 0.2, 0.7, 0.8 ])
        translate([ 0, 0, -ring_gear_thickness - motor_mount_hole_depth - (motor_mount_wall_thickness * 2) ])
            carrier();
    } else {
        if (HAS_RING)
        {
            ring_gear();
        }

        if (HAS_PLANETS)
        {
            for (i = [ 0 : num_of_planets - 1 ])
            {
                translate([ planet_gear_pitch_diameter * 1.2 * (i - 1), 0, 0 ])
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

        if (HAS_PROPELLER)
        {
            propeller();
        }
    }
}

HAS_RING = false;
HAS_PLANETS = false;
HAS_SUN = true;
HAS_CARRIER = false;
HAS_PROPELLER = false;

DEBUG = false;

ASSEMBLY = false;

$slop = 0.15;
PRINTER_SLOP = $slop;
$fn = 256;
GEAR_SLICES = 12;

profan(
    num_of_planets = 2,
    num_of_propellers = 3,
    ring_gear_num_of_teeth = 96,
    planet_gear_num_of_teeth = 32,
    case_size = 140,
    ring_gear_pitch_diameter = 130,
    helical = 0,
    motor_mount_hole_depth = 20,
    motor_mount_hole_diameter = 50,
    motor_mount_wall_thickness = 2.5
);
