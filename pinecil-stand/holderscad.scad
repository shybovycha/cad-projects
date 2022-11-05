include <BOSL2/std.scad>;
include <BOSL2/shapes3d.scad>;
include <BOSL2/walls.scad>;
include <BOSL2/drawing.scad>;

module holder()
{
    difference()
    {
        union()
        {
            // front wall
            difference()
            {
                // front wall
                cuboid([ 25, 10, 25 ], chamfer=3, trimcorners=false, edges=[TOP+LEFT, TOP+RIGHT]);
                
                // central hole
                translate([ 0, 15, 0 ])
                    cylinder(h=30, d=11.5, orient=FWD, $fn=128);
                
                // top hole
                translate([ 0, 0, 11.5 ])
                    cuboid([ 8, 15, 15 ]);
            }
            
            // platform
            difference()
            {
                // platform body
                translate([ 0, ((42 + 15) / 2) + 5, -(13 / 2) + 0.5 ])
                    cuboid([ 25, 42 + 15, 13 ], chamfer=3, trimcorners=false, edges=[TOP+RIGHT, TOP+LEFT]);
                
                // inlet
                translate([ 0, (42 + 15 + 10) / 2, -(8 / 2) ])
                    cuboid([ 16, 42 + 15 + 10, 10 ], chamfer=1, trimcorners=false, edges=[BOTTOM+LEFT, BOTTOM+RIGHT]);
            }
            
            // bottom with trimmed corners
            translate([ 0, (42 + 15) / 2, -25 / 2 ])
                cuboid([ 25, (42 + 15 + 10), 2 ], chamfer=1, trimcorners=false, edges=[FRONT+BOTTOM, BACK+BOTTOM, BOTTOM+LEFT, BOTTOM+RIGHT]);
        }
        
        // dovetail inlet
        translate([ 0, ((15 + 30) / 2) - 0.5, -((25 / 2) + 2) ])
            prismoid(size1 = [ 8 + 0.5, 10 + 15 + 30 ], size2 = [ 12 + 0.5, 10 + 15 + 30 ], h = 4);
    }
}

module stand()
{
    union()
    {
        // dovetail
        translate([ 0, -4, 0 ])
            rotate([ 30, 0, 0 ])
                prismoid(size1 = [ 8, 23.1 ], size2 = [ 12, 23.1 ], h = 4);
        
        // stem
        translate([ 0, (-10 / cos(30)) + 1.6 - 4, (-68 / 2) + 0.76 ])
            rotate([ 0, -90, -90 ])
                prismoid(size1 = [ 55, 8 ], size2 = [ 55 + (10 / cos(30)), 8 ], shift = [ 5 / cos(30), 0 ], h = 10 / sin(30) - 0.1);
        
        // legs
        translate([ 0, (64) / 2 + (8 / 2) - 0.1 + 6, -(65 - (10 / 2)) - 1 ])
            difference()
            {
                cylinder(d=(64 + (8 * 2) + 0.5), h=10, $fn=200);
                
                translate([ 0, 0, -1 ])
                    cylinder(d=64 + 8 - 0.25, h=12, $fn=200);
            }
            
        // stem support - bottom
        translate([ 0, -8/2 - 5 - 4, -64 + (8 / 2) + 8 + 1 ])
            rotate([ 0, -90, 180 ])
                interior_fillet(l=8, r=25, ang=90, $fn=200);
            
        translate([ 0, -35 / 2 - 5 - 4, -64 + (8 / 2) + (10 / 2) - 1 ])
            cuboid([ 8, 35, 10 ], chamfer=3, edges=[FRONT+TOP]);
            
        // bottom
        difference()
        {
            union()
            {
                translate([ 0, (64) / 2 + (8 / 2) - 0.1 + 6, -(65 - (10 / 2)) - 1 - 2.5 ])
                    cylinder(d=(64 + (8 * 2) + 0.5), h=5, $fn=200);
                
                translate([ 0, -64/2 + 2 - 4, -(65 - (10 / 2)) - 1 - 2.5 ])
                        cylinder(d=64, h=10, $fn=200);
                
                translate([ 0, -64/2 - 4, -(65 - (10 / 2)) - 1 + 2.5 ])
                    rotate([ -90, 0, 0 ])
                        prismoid(size1=[64, 10], size2=[(64 + (8 * 2) - 2), 10], h=64 + 8);
            }
            
            translate([ 0, (64) / 2 + (8 / 2) - 0.1 + 6, -(65 - (10 / 2)) - 1 ])
                cylinder(d=(64 + (8 * 2) + 0.5), h=10, $fn=200);
                
            translate([ 0, (64) / 2 + (8 / 2) - 0.1 + 6, -(65 - (10 / 2)) - 1 ])
                translate([ 0, 0, -1 ])
                    cylinder(d=64 + 8 - 0.25, h=12, $fn=200);
        }
    }
}

// holder();

translate([ 0, 0, 64 / 2 ])
stand();
