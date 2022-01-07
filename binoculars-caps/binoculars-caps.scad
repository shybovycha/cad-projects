include <BOSL/shapes.scad>;

module lens_cap(
    height,
    outer_diameter,
    inner_diameter,
    cap_thickness,
    line_hole_size = 5,
    thickeners = false)
{
    $fn = 128;
    
    hole_mount_thickness = (2 * cap_thickness);
    
    union()
    {
        difference()
        {
            cyl(l = height + cap_thickness, d = outer_diameter, chamfer1 = 0, fillet2 = 1);
            
            translate([ 0, 0, -cap_thickness ])
                cyl(l = height, d = inner_diameter, chamfer1 = 0, fillet2 = 0.5);
        }
        
        difference()
        {
            translate([ (outer_diameter / 2) - (hole_mount_thickness / 2), 0, -(height / 2) + hole_mount_thickness ])
                prismoid(size1 = [ hole_mount_thickness + line_hole_size, hole_mount_thickness ], size2 = [ hole_mount_thickness, hole_mount_thickness  ], h = line_hole_size / 2 + cap_thickness, orient = ORIENT_X);
            
            translate([ (outer_diameter / 2) + (hole_mount_thickness / 2), 0, -(height / 2) + hole_mount_thickness ])
                cube([ hole_mount_thickness * 0.25, line_hole_size * 0.5, hole_mount_thickness * 1.5 ], center = true);
        }
        
        if (thickeners)
        {
            for (a = [ 0 : 3 ])
            {
                translate([ cos(a * 90) * inner_diameter / 2, sin(a * 90) * inner_diameter / 2, 0 ])
                    cyl(l = height, d = 2);
            }
        }
    }
}

// big lens cap
translate([ 0, 60, 0 ])
    lens_cap(height = 15, cap_thickness = 1.25, outer_diameter = 55, inner_diameter = 52.5, thickeners = true);

// small lens cap
translate([ 0, 0, 0 ])
    lens_cap(height = 12, cap_thickness = 1.25, outer_diameter = 41, inner_diameter = 38.7);
