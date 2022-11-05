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
        rotate([ 30, 0, 0 ])
            prismoid(size1 = [ 8, 20 ], size2 = [ 12, 20 ], h = 4);
        
        // stem
        translate([ 0, 0, -(65 / 2) + 4 ])
            cuboid([ 8, 8, 65 ], chamfer=4, edges=[FRONT+TOP]);
        
        // legs
        translate([ 0, (64) / 2 + (8 / 2) - 0.1, -(65 - (10 / 2)) - 1 ])
            difference()
            {
                cylinder(d=(64 + (8 * 2) + 0.5), h=10, $fn=200);
                
                translate([ 0, 0, -1 ])
                    cylinder(d=64 - 0.25, h=12, $fn=200);
                
                translate([ 0, (64 * 3 / 4), ((10 + 1) / 2) ])
                    cuboid([ 64 + (8 * 2) + 2, 64, 10 + 2 ]);
            }
            
        // stem support - top
        // translate([ 0, 0, -2 ])
            // prismoid(size1 = [ 8, 4 ], size2 = [ 8, 5 ], shift = [ 0, 5 ], h = 5);
            
        /*translate([ 0, -8 / 2, -8 / 2 ])
            rotate([ 0, 90, 180 ])
                interior_fillet(l=8, r=5, ang=90, $fn=128);
            
        translate([ 0, -8 / 2, -4 / 2 ])
            cuboid([ 8, 8, 4 ]);
            
        translate([ 0, 8 / 2, 4 ])
            rotate([ 0, 90, 0 ])
                interior_fillet(l=8, r=4, ang=90, $fn=128);
            
        //translate([ 0, 8 / 2, 4 ])
            //cuboid([ 8, 8, 2 ]);*/
            
        // stem support - bottom
        translate([ 0, -8 / 2, -64 + (8 / 2) + 8 + 1 ])
            rotate([ 0, -90, 180 ])
                interior_fillet(l=8, r=25, ang=90, $fn=200);
            
        translate([ 0, -35 / 2, -64 + (8 / 2) + (10 / 2) - 1 ])
            cuboid([ 8, 35, 10 ], chamfer=3, edges=[FRONT+TOP]);
    }
}

// holder();

translate([ 0, 0, 64 / 2 ])
stand();
