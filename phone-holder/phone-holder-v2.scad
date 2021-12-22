// use <BOSL/constants.scad>;
use <BOSL/threading.scad>;
use <BOSL/shapes.scad>;
use <BOSL/involute_gears.scad>;

module phone_holder(closed_width, open_width, back_holder_length, case_height, case_depth)
{
    rack_travel_distance = (open_width - closed_width) / 2;
    rack_length = (open_width / 2) + rack_travel_distance;
    
    rack_mm_per_tooth = 1.5;
    rack_number_of_teeth = rack_travel_distance / rack_mm_per_tooth;
    
    rack_thickness = case_depth / 2;
    
    rail_non_teethed_length = closed_width - rack_travel_distance;
    rail_height = case_depth;
    
    rack_tooth_height = adendum(mm_per_tooth = rack_mm_per_tooth);
    
    // TODO: change
    rack_driver_gear_number_of_teeth = 15;
    
    worm_wheel_number_of_teeth = rack_driver_gear_number_of_teeth / 2;
    
    worm_wheel_thickness = rack_thickness / 2;
    rack_driver_gear_thickness = rack_thickness;

    rack_driver_gear_outer_radius = outer_radius(mm_per_tooth = rack_mm_per_tooth, number_of_teeth = rack_driver_gear_number_of_teeth);
    
    rail_length = (rack_travel_distance * 2) + rail_non_teethed_length;
    
    groove_depth = rack_thickness / 3;
     
    module top_rail()
    {
        difference()
        {
            union()
            {
                translate([ -rail_non_teethed_length, -rail_height, 0 ])
                    // cube([ rack_travel_distance, rail_height - (rack_tooth_height * 2), rack_thickness ], center = false);
                    cube([ rail_non_teethed_length, rail_height - (rack_tooth_height * 2), rack_thickness ], center = false);
                
                translate([ rack_mm_per_tooth / 2, -rack_tooth_height, rack_thickness / 2 ])
                    rack(mm_per_tooth = rack_mm_per_tooth, number_of_teeth = rack_number_of_teeth, thickness = rack_thickness, height = rail_height, pressure_angle = 20);
                
                translate([ rack_travel_distance - rack_mm_per_tooth, -rail_height, 0 ])
                    cube([ rack_travel_distance, rail_height - (rack_tooth_height * 2), rack_thickness ], center = false);
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
                cube([ (rack_travel_distance * 2) + rail_non_teethed_length, rail_height - (rack_tooth_height * 2), rack_thickness - groove_depth ], center = false);
            
            // groove mount
            translate([ -(2 * rack_mm_per_tooth), -((rail_height / 2) + rack_tooth_height), rack_thickness - groove_depth ])
                prismoid(size2 = [ rail_length, (rail_height * 2 / 3) * (1 - PRINTER_SLOP * 2) ], size1 = [ rail_length, (rail_height / 2) * (1 - PRINTER_SLOP * 2) ], h = groove_depth, center = false);
        }
    }
    
    module rack_driver_gear()
    {
        union()
        {
            gear(mm_per_tooth = rack_mm_per_tooth, number_of_teeth = rack_driver_gear_number_of_teeth, thickness = rack_driver_gear_thickness, hole_diameter = 0);
            
            translate([ 0, 0, -(rack_driver_gear_thickness / 2 + worm_wheel_thickness / 2) ])
                gear(mm_per_tooth = rack_mm_per_tooth, number_of_teeth = worm_wheel_number_of_teeth, thickness = worm_wheel_thickness, hole_diameter = 0);
        }
    }
    
    top_rail();
    
    translate([ 0, (rack_driver_gear_outer_radius * 2) + (rail_height - rack_tooth_height / 2), 0 ])
        bottom_rail();
    
    translate([ 0, rack_driver_gear_outer_radius, (rack_driver_gear_thickness / 2) ])
        rotate([ 180, 0, 0 ])
            rack_driver_gear();
}

$fn = 32;
PRINTER_SLOP = 0.05;

phone_holder(
    closed_width = 80,
    open_width = 130,
    back_holder_length = 100,
    case_height = 5,
    case_depth = 12.5
);
