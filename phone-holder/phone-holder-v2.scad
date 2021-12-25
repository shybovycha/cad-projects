use <BOSL/threading.scad>;
use <BOSL/shapes.scad>;
use <BOSL/involute_gears.scad>;

include <BOSL/constants.scad>;

module phone_holder(closed_width, open_width, back_holder_length, case_thickness, case_depth, axis_radius, axis_length, side_brim_height1, side_brim_height2, bottom_brim_height1, bottom_brim_height2)
{
    rack_travel_distance = (open_width - closed_width) * 1.15;
    rack_length = (open_width / 2) + rack_travel_distance;

    rack_mm_per_tooth = 1.5;
    rack_number_of_teeth = rack_travel_distance / rack_mm_per_tooth;

    rack_thickness = case_depth / 2;

    rail_non_teethed_length = closed_width - rack_travel_distance;
    rail_height = case_depth;

    rack_tooth_height = adendum(mm_per_tooth = rack_mm_per_tooth) + dedendum(mm_per_tooth = rack_mm_per_tooth);

    // TODO: change
    rack_driver_gear_number_of_teeth = 32;

    // TODO: make a param?
    worm_wheel_number_of_teeth = 8;
    
    // TODO: make a param:
    axis_thread_length = 10;

    worm_wheel_thickness = rack_thickness / 2;
    rack_driver_gear_thickness = rack_thickness - (PRINTER_SLOP * 4);
    
    rack_driver_gear_outer_radius = outer_radius(mm_per_tooth = rack_mm_per_tooth, number_of_teeth = rack_driver_gear_number_of_teeth);
    
    worm_wheel_outer_radius = outer_radius(mm_per_tooth = rack_mm_per_tooth, number_of_teeth = worm_wheel_number_of_teeth);
    
    worm_wheel_mm_per_tooth = rack_mm_per_tooth * 2;
    
    worm_wheel_tooth_height = adendum(mm_per_tooth = worm_wheel_mm_per_tooth) + dedendum(mm_per_tooth = worm_wheel_mm_per_tooth);

    rail_length = (rack_travel_distance * 2) + rail_non_teethed_length - rack_mm_per_tooth;

    groove_depth = rack_thickness / 3;

    axis_rod_length = axis_length + back_holder_length; // TODO: + case and mounts
    
    worm_wheel_pitch_radius = pitch_radius(mm_per_tooth = worm_wheel_mm_per_tooth, number_of_teeth = worm_wheel_number_of_teeth);
    
    rack_driver_gear_pitch_radius = pitch_radius(mm_per_tooth = rack_mm_per_tooth, number_of_teeth = rack_driver_gear_number_of_teeth);

    module top_rail()
    {
        difference()
        {
            union()
            {
                translate([ -rail_non_teethed_length, -rail_height - rack_tooth_height / 2, 0 ])
                    // cube([ rack_travel_distance, rail_height - (rack_tooth_height * 2), rack_thickness ], center = false);
                    cube([ rail_non_teethed_length, rail_height - rack_tooth_height, rack_driver_gear_thickness ], center = false);

                translate([ rack_mm_per_tooth / 2, -rack_tooth_height, rack_thickness / 2 ])
                    rack(mm_per_tooth = rack_mm_per_tooth, number_of_teeth = rack_number_of_teeth, thickness = rack_driver_gear_thickness, height = rail_height, pressure_angle = 20);

                // translate([ rack_travel_distance - rack_mm_per_tooth, -(rail_height + (rack_tooth_height / 2)), 0 ])
                    // cube([ rack_travel_distance, rail_height - rack_tooth_height, rack_thickness ], center = false);
                
                // side brim mount
                translate([ -rail_non_teethed_length - case_thickness / 2, -(rack_tooth_height * 2 + (rail_height - (rack_tooth_height * 2)) / 2), (case_thickness / 2) ])
                    rotate([ 90, 0, 0 ])
                        rotate([ 0, 90, 0 ])
                            prismoid(size1 = [ rail_height - (rack_tooth_height * 2), case_thickness / 2 ], size2 = [ (rail_height - (rack_tooth_height * 2)) / 2, case_thickness / 3 ], h = case_thickness / 2, center = false);
                
                // from brim:
            // prismoid(size1 = [ length * 1.25, thickness / 2 ], size2 = [ length * 1.25, thickness / 3 ], h = (thickness / 2) + PRINTER_SLOP, center = false);
            // side brim:
            // brim(length = closed_width / 2, height1 = side_brim_height1, height2 = side_brim_height2, depth = case_depth, thickness = case_thickness);
            // hence:
            // prismoid(size1 = [ rail_width, thickness / 2 ], size2 = [ rail_width / 2, thickness / 3 ], h = thickness / 2, center = false)
            // substitute:
            // prismoid(size1 = [ rail_height - (rack_tooth_height * 2), case_thickness / 2 ], size2 = [ (rail_height - (rack_tooth_height * 2)) / 2, case_thickness / 3 ], h = case_thickness / 2, center = false)
            }

            // groove
            translate([ 0, -((rail_height / 2) + rack_tooth_height), rack_thickness - groove_depth + PRINTER_SLOP ])
                prismoid(size1 = [ rail_length * 1.5, rail_height * 2 / 3 ], size2 = [ rail_length * 1.5, rail_height / 2 ], h = groove_depth, center = false);
        }
    }

    module bottom_rail()
    {
        union()
        {
            translate([ -((rail_length / 2) + (2 * rack_mm_per_tooth)), -rail_height, 0 ])
                cube([ (rack_travel_distance * 2) + rail_non_teethed_length - (rack_mm_per_tooth), rail_height - (rack_tooth_height * 2), rack_thickness - groove_depth ], center = false);

            // groove mount
            translate([ -(2 * rack_mm_per_tooth), -((rail_height / 2) + rack_tooth_height), rack_thickness - groove_depth ])
                prismoid(size1 = [ rail_length, (rail_height / 2) * (1 - PRINTER_SLOP * 2) ], size2 = [ rail_length, (rail_height * 2 / 3) * (1 - PRINTER_SLOP * 2) ], h = groove_depth, center = false);
            
            // side brim mount
            // translate([ ((rack_travel_distance * 2) + rail_non_teethed_length - (rack_mm_per_tooth * 2)) / 2, -(rack_tooth_height * 2 + (rail_height - (rack_tooth_height * 2)) / 2), (case_thickness / 2) ])
                // rotate([ 90, 0, 0 ])
                    // rotate([ 0, -90, 0 ])
                        // prismoid(size1 = [ rail_height - (rack_tooth_height * 2), case_thickness / 2 ], size2 = [ (rail_height - (rack_tooth_height * 2)) / 2, case_thickness / 3 ], h = case_thickness / 2, center = false);
        }
    }

    module rack_driver_gear()
    {
        union()
        {
            gear(mm_per_tooth = rack_mm_per_tooth, number_of_teeth = rack_driver_gear_number_of_teeth, thickness = rack_driver_gear_thickness, hole_diameter = 0);

            translate([ 0, 0, -(rack_driver_gear_thickness / 2 + worm_wheel_thickness / 2) ])
                gear(mm_per_tooth = worm_wheel_mm_per_tooth, number_of_teeth = worm_wheel_number_of_teeth, thickness = worm_wheel_thickness, hole_diameter = 0);
        }
    }

    module axis()
    {
        union()
        {
            translate([ 0, 0, axis_thread_length / 2 ])
                cylinder(r = axis_radius, h = (back_holder_length / 2) - (axis_thread_length / 2), center = false);

            trapezoidal_threaded_rod(d = axis_radius * 2, l = axis_thread_length, pitch = circular_pitch(mm_per_tooth = worm_wheel_mm_per_tooth), thread_depth = worm_wheel_tooth_height);

            translate([ 0, 0, - ((back_holder_length / 2) + axis_length) ])
                cylinder(r = axis_radius, h = (back_holder_length / 2) - (axis_thread_length / 2) + axis_length, center = false);
        }
    }

    module brim(length, height1, height2, depth, thickness, fillet = 2, hole = 0)
    {
        difference()
        {
            union()
            {
                cuboid([ length, thickness, height1 ], fillet = fillet, edges = EDGE_FR_LF + EDGE_FR_RT, center = false);

                translate([ 0, 0, -thickness ])
                    cuboid([ length, depth + (2 * thickness), thickness ], fillet = fillet, edges = EDGE_BOT_BK + EDGE_BK_RT + EDGE_BK_LF + EDGE_BOT_FR + EDGE_FR_LF + EDGE_FR_RT + EDGE_BOT_RT + EDGE_BOT_LF, center = false);

                translate([ 0, depth + thickness, 0 ])
                   cuboid([ length, thickness, height2 ], fillet = fillet, edges = EDGE_TOP_FR + EDGE_TOP_BK + EDGE_BK_LF + EDGE_BK_RT, center = false);

                translate([ length / 2, thickness, 0 ])
                    interior_fillet(l = length, r = fillet);

                translate([ length / 2, depth + thickness, 0 ])
                    interior_fillet(l = length, r = fillet, orient = ORIENT_X_90);
            }
            
            // groove
            translate([ length / 2, thickness / 2, height1 - (thickness / 2) ])
                prismoid(size1 = [ length * 1.25, thickness / 2 ], size2 = [ length * 1.25, thickness / 3 ], h = (thickness / 2) + PRINTER_SLOP, center = false);
            
            // hole
            if (hole > 0)
            {
                translate([ length / 2, (depth + thickness + (depth / 2) ) / 2, 0 ])
                    cuboid([ hole, depth / 2, thickness * 2 + (2 * PRINTER_SLOP) ], fillet = fillet, edges = EDGE_FR_LF + EDGE_FR_RT + EDGE_BK_RT + EDGE_BK_LF);
            }
        }
    }
    
    module case_front(fillet = 4)
    {
        difference()
        {
            union()
            {
                cuboid([ closed_width, back_holder_length, rack_thickness + (case_thickness / 2) ], fillet = fillet, edges = EDGE_BK_LF + EDGE_BK_RT + EDGE_BOT_LF + EDGE_BOT_RT + EDGE_BOT_BK, center = false);
                
                translate([ closed_width / 2, -case_thickness / 2, (rack_thickness + (case_thickness / 2)) / 2 ])
                    rotate([ -90, 0, 0 ])
                        prismoid(size1 = [ closed_width, (case_thickness / 2) - (PRINTER_SLOP * 2) ], size2 = [ closed_width, case_thickness / 3 ], h = case_thickness / 2, center = false);
                
                // top axis support
                difference()
                {
                    union()
                    {
                        translate([ (closed_width / 2) + worm_wheel_pitch_radius + (axis_radius - worm_wheel_tooth_height / 2), back_holder_length - (case_thickness / 2), rack_thickness + axis_radius ])
                            cube([ (axis_radius * 2) + case_thickness, case_thickness, axis_radius + case_thickness / 2 ], center = true);
                        
                        translate([ (closed_width / 2) + worm_wheel_pitch_radius + (axis_radius - worm_wheel_tooth_height / 2), back_holder_length  - (case_thickness / 2), rack_thickness + (case_thickness / 2) + axis_radius + (PRINTER_SLOP * 5) ])
                            rotate([ 90, 0, 0 ])
                                cylinder(r = axis_radius + (case_thickness / 2), h = case_thickness, center = true);
                    }
                    
                    translate([ (closed_width / 2) + worm_wheel_pitch_radius + (axis_radius - worm_wheel_tooth_height / 2), back_holder_length + case_thickness * 2, rack_thickness + (case_thickness / 2) + axis_radius + (PRINTER_SLOP * 5) ])
                    rotate([ 90, 0, 0 ])
                        cylinder(r = axis_radius * (1 + PRINTER_SLOP), h = case_thickness * 4, center = false);
                }
                
                // bottom axis support
                difference()
                {
                    union()
                    {
                        translate([ (closed_width / 2) + worm_wheel_pitch_radius + (axis_radius - worm_wheel_tooth_height / 2), (case_thickness / 2), rack_thickness + axis_radius ])
                            cube([ (axis_radius * 2) + case_thickness, case_thickness, axis_radius + case_thickness / 2 ], center = true);
                        
                        translate([ (closed_width / 2) + worm_wheel_pitch_radius + (axis_radius - worm_wheel_tooth_height / 2), (case_thickness / 2), rack_thickness + (case_thickness / 2) + axis_radius + (PRINTER_SLOP * 5) ])
                            rotate([ 90, 0, 0 ])
                                cylinder(r = axis_radius + (case_thickness / 2), h = case_thickness, center = true);
                    }
                    
                    translate([ (closed_width / 2) + worm_wheel_pitch_radius + (axis_radius - worm_wheel_tooth_height / 2), case_thickness * 2, rack_thickness + (case_thickness / 2) + axis_radius + (PRINTER_SLOP * 5) ])
                    rotate([ 90, 0, 0 ])
                        cylinder(r = axis_radius * (1 + PRINTER_SLOP), h = case_thickness * 4, center = false);
                }
            }
            
            // top rail groove
            translate([ -closed_width / 2, (back_holder_length / 2) + rack_driver_gear_pitch_radius - rack_tooth_height / 2, rack_thickness / 2 ])
                cube([ closed_width * 2.5, rail_height + rack_tooth_height, rack_thickness + PRINTER_SLOP ], center = false);
            
            // drive gear groove
            translate([ closed_width / 2, (back_holder_length / 2), rack_thickness / 2 ])
                    cylinder(r = rack_driver_gear_outer_radius + rack_tooth_height, h = rack_driver_gear_thickness + PRINTER_SLOP, center = false);
            
            // bottom rail groove
            translate([ -closed_width / 2, (back_holder_length / 2) - rack_driver_gear_pitch_radius - (rail_height - rack_tooth_height / 2), rack_thickness / 2 ])
                cube([ closed_width * 2.5, rail_height + rack_tooth_height, rack_thickness + PRINTER_SLOP ], center = false);
        }
    }
    
    module case_back(fillet = 4)
    {
        difference()
        {
            union()
            {
                cuboid([ closed_width, back_holder_length, (axis_radius * 2) + (case_thickness / 2) ], fillet = fillet, edges = EDGE_BK_LF + EDGE_BK_RT + EDGE_BOT_LF + EDGE_BOT_RT + EDGE_BOT_BK, center = false);
                
                translate([ closed_width / 2, -case_thickness / 2, (rack_thickness + (case_thickness / 2)) / 2 ])
                    rotate([ -90, 0, 0 ])
                        prismoid(size1 = [ closed_width, case_thickness / 2 ], size2 = [ closed_width, case_thickness / 3 ], h = case_thickness / 2, center = false);
            }
                
            translate([ (closed_width / 2) + rack_tooth_height / 2 + axis_radius * 1.25, back_holder_length + PRINTER_SLOP, rack_thickness - (case_thickness / 2) + axis_radius * 1.5 * (1 + PRINTER_SLOP * 2) ])
                rotate([ 90, 0, 0 ])
                    cylinder(r = axis_radius * 1.25, h = case_thickness, center = false);

            translate([ (closed_width / 2) + rack_tooth_height / 2 + axis_radius * 1.25, case_thickness - PRINTER_SLOP, rack_thickness - (case_thickness / 2) + axis_radius * 1.5 * (1 + PRINTER_SLOP * 2) ])
                rotate([ 90, 0, 0 ])
                    cylinder(r = axis_radius * 1.25, h = case_thickness, center = false);
                    
            translate([ closed_width / 2, (back_holder_length / 2), rack_thickness + worm_wheel_thickness / 2 ])
                cylinder(r = worm_wheel_outer_radius + rack_tooth_height, h = worm_wheel_thickness + PRINTER_SLOP, center = false);
        }
    }

    translate([ -60, 7, 0 ])
        top_rail();

    //translate([ -40, 23, 0 ])
        //top_rail();
    
    translate([ 10, 0, 5 ])
        rotate([ 180, 0, 0 ])
            rack_driver_gear();
    
    translate([ -5, -15, 5 ])
        rotate([ 0, 90, 0 ])
            axis();

    // bottom brim
    translate([ 30, 10, 9 ])
        rotate([ 0, 0, 90 ])
            brim(length = closed_width, height1 = bottom_brim_height1, height2 = bottom_brim_height2, depth = case_depth, thickness = rack_thickness + (case_thickness / 2), hole = case_depth);

    // side brim
    //translate([ 70, -18, 5 ])
        //rotate([ 0, 0, 90 ])
            //brim(length = closed_width / 2, height1 = side_brim_height1, height2 = side_brim_height2, depth = case_depth, thickness = case_thickness);
            
    //translate([ 100, 5, 5 ])
        //rotate([ 0, 0, 90 ])
            //brim(length = closed_width / 2, height1 = side_brim_height1, height2 = side_brim_height2, depth = case_depth, thickness = case_thickness);
            
    translate([ -85, 12, 0 ])
        case_front();
        
    //translate([ -5, 30, 0 ])
        //case_back();
        
    // TODO: DEBUG INFO
    /*translate([ -45, 62, 5 ])
        rotate([ 180, 0, 0 ])
            rack_driver_gear();
            
    translate([ -60, 55.7, 5 ])
        top_rail();
            
    translate([ -38, 62, 13 ])
        rotate([ 90, 0, 0 ])
            axis();*/
}

$fn = 32;
PRINTER_SLOP = 0.05;

phone_holder(
    closed_width = 80,
    open_width = 130,
    back_holder_length = 100,
    case_thickness = 5,
    case_depth = 12.5,
    axis_radius = 4,
    axis_length = 30,
    side_brim_height1 = 20,
    side_brim_height2 = 10,
    bottom_brim_height1 = 20,
    bottom_brim_height2 = 10
);
