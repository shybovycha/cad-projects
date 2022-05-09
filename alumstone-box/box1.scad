include <BOSL2/std.scad>

wall_thickness = 4;
$slop = 0.25;

$fn = 64;

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

translate([ 0, 80, 0 ])
difference()
{
    union()
    {
        prismoid(size1 = [55 + wall_thickness / 2, 30 + wall_thickness / 2], size2 = [55 + wall_thickness / 2, 30 + wall_thickness / 2], chamfer = 5, h = 70 + wall_thickness / 2);
        
        translate([ 0, 0, -wall_thickness ])
        prismoid(size1 = [55 + wall_thickness + $slop, 30 + wall_thickness + $slop], size2 = [55 + wall_thickness + $slop, 30 + wall_thickness + $slop], chamfer = 5, h = wall_thickness);
    }

    translate([ 0, 10, -$slop ])
    prismoid(size1 = [55, 40], size2 = [55, 40], chamfer = 5, h = 70);
    
    translate([ -8, 0, 70 + wall_thickness ])
    cyl(r = 1, h = wall_thickness * 4);
    
    translate([ 8, 0, 70 + wall_thickness ])
    cyl(r = 1, h = wall_thickness * 4);
}
