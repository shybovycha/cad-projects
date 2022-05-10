include <BOSL2/std.scad>

wall_thickness = 4;
$slop = 0.5;

$fn = 64;

HAS_OUTER_BOX = false;
HAS_INNER_BOX = true;

if (HAS_OUTER_BOX)
{
    difference()
    {
        prismoid(size1 = [55 + wall_thickness + $slop, 30 + wall_thickness + $slop], size2 = [55 + wall_thickness + $slop, 30 + wall_thickness + $slop], chamfer = 5, h = 70 + wall_thickness + $slop);

        translate([ 0, 0, -wall_thickness / 2 ])
        prismoid(size1 = [55, 30], size2 = [55, 30], chamfer = 5, h = 70);
        
        translate([ -8, 0, 70 + wall_thickness ])
        cyl(r = 1, h = wall_thickness * 4);
        
        cyl(r = 1, h = wall_thickness * 4);
        
        translate([ 8, 0, 70 + wall_thickness ])
        cyl(r = 1, h = wall_thickness * 4);
    }
}

if (HAS_INNER_BOX)
{
    // translate([ 0, 0, -70 ])
    difference()
    {
        union()
        {
            // prismoid(size1 = [55 + wall_thickness / 2, 30 + wall_thickness / 2], size2 = [55 + wall_thickness / 2, 30 + wall_thickness / 2], chamfer = 5, h = 70 + wall_thickness / 2);
            prismoid(size1 = [55 - $slop, 30 - $slop], size2 = [55 - $slop, 30 - $slop], chamfer = 5, h = 70 - $slop);
            
            translate([ 0, 0, -wall_thickness / 2 - $slop ])
                prismoid(size1 = [55 + wall_thickness + $slop, 30 + wall_thickness + $slop], size2 = [55 + wall_thickness + $slop, 30 + wall_thickness + $slop], chamfer = 5, h = wall_thickness);
        }

        translate([ 0, wall_thickness, wall_thickness / 2 - $slop ])
            // prismoid(size1 = [55, 40], size2 = [55, 40], chamfer = 5, h = 70);
            prismoid(size1 = [55 - wall_thickness, 35 - wall_thickness], size2 = [55 - wall_thickness, 35 - wall_thickness], chamfer = 5, h = 70 - wall_thickness);
        
        translate([ -8, 0, 70 + wall_thickness ])
            cyl(r = 1.5, h = wall_thickness * 4);
        
        translate([ 8, 0, 70 + wall_thickness ])
            cyl(r = 1.5, h = wall_thickness * 4);
    }
}
