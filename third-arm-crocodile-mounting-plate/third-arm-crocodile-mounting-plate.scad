include <BOSL2/std.scad>;
include <BOSL2/shapes3d.scad>;

module plate()
{
    plate_thickness = 2;
    plate_width = 10;
    plate_length = 25;
    
    hole_diameter = 4;
    
    mounting_pole_height = 6;
    
    difference()
    {
        union()
        {
            translate([ 0, (plate_length / 2) - (plate_width / 2), 0 ])
                cyl(r = plate_width / 2, h = plate_thickness);
            
            cuboid(size = [ plate_width, plate_length - (2 * (plate_width / 2)), plate_thickness ]);
            
            translate([ 0, 0, (plate_thickness / 2) + (mounting_pole_height / 2) ])
                cyl(d = plate_width * 0.9, h = mounting_pole_height);
            
            translate([ 0, -((plate_length / 2)  - (plate_width / 2)), 0 ])
                cyl(r = plate_width / 2, h = plate_thickness);
        }
        
        translate([ 0, (plate_length / 2) - (plate_width / 2), 0 ])
            cyl(d = hole_diameter, h = plate_thickness + (2 * $slop));
        
        cyl(d = hole_diameter + (2 * $slop), h = (plate_thickness * 4) + mounting_pole_height + (2 * $slop));
        
        translate([ 0, -((plate_length / 2) - (plate_width / 2)), 0 ])
            cyl(d = hole_diameter, h = plate_thickness + (2 * $slop));
    }
}

$slop = 0.16;
$fn = 256;

plate();
