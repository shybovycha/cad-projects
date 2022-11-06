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
    $fn = 256;
    
    dovetail_incline_angle = 30; // degrees, around x axis
    dovetail_length = 20; // mm, along y axis
    
    back_legs_spread_angle = 45; // degrees, around y axis
    
    back_legs_support_angle = 85;
    
    stem_height = 70;
    
    dovetail_vertical_height = dovetail_length * sin(dovetail_incline_angle);
    dovetail_horizontal_length = dovetail_length * cos(dovetail_incline_angle);
    
    leg_length = stem_height / cos(dovetail_incline_angle);
    leg_vertical_height = leg_length * cos(dovetail_incline_angle);
    leg_horizontal_length = leg_length * sin(back_legs_support_angle);
    
    leg_spread_length = 2 * leg_horizontal_length * sin(back_legs_spread_angle);
    
    stem_offset = dovetail_vertical_height / 4;
    
    leg_offset = leg_length * sin(back_legs_support_angle);
    
    union()
    {
        // dovetail
        rotate([ dovetail_incline_angle, 0, 0 ])
            prismoid(size1 = [ 8, dovetail_length ], size2 = [ 12, dovetail_length ], h = 4);

        // joint
        translate([ 0, 0, -dovetail_vertical_height / 2 ])
            prismoid(size1 = [ 8, dovetail_horizontal_length ], size2 = [ 8, 0 ], shift = [ 0, dovetail_horizontal_length / 2 ], h = dovetail_vertical_height, orient = UP);
        
        // legs
        // difference()
        {
            translate([ 0, 0, -dovetail_vertical_height / 2 ])
                // prismoid(size1 = [ 8, dovetail_horizontal_length ], size2 = [ leg_spread_length, leg_horizontal_length ], shift = [ 0, -dovetail_horizontal_length / 2 + leg_horizontal_length / 2 ], h = leg_vertical_height, orient = DOWN);
                prismoid(size1 = [ 8, dovetail_horizontal_length ], size2 = [ 8, dovetail_horizontal_length ], shift = [ 0, -dovetail_horizontal_length / 2 + leg_offset / 2 ], h = leg_vertical_height, orient = DOWN);
            
            /*translate([ 0, dovetail_horizontal_length / 4, -leg_vertical_height / 2 ])
                cyl(l = leg_horizontal_length + 2, d = leg_horizontal_length / 3, orient = RIGHT);
            
            translate([ 0, dovetail_horizontal_length / 4, -leg_vertical_height / 2 ])
                prismoid(
                    size1 = [ 
                        leg_spread_length + 2,
                        leg_horizontal_length / 3
                    ],
                    size2 = [
                        leg_spread_length + 2,
                        (leg_horizontal_length - leg_horizontal_length / 3)
                    ],
                    shift = [
                        0,
                        ((leg_horizontal_length - leg_horizontal_length / 3) - (leg_horizontal_length / 3)) / 2
                    ],
                    h = leg_vertical_height / 2 + leg_horizontal_length / 3,
                    orient = DOWN
                );
                
            translate([ 0, dovetail_horizontal_length / 4, -leg_vertical_height + leg_spread_length / 3 ])
                cyl(l = leg_horizontal_length * 1.25, d = leg_spread_length / 2, orient = FWD);
                
            /*translate([ 0, dovetail_horizontal_length / 4, -leg_vertical_height / 2 - leg_spread_length / 2 ])
                prismoid(
                    size1 = [ 
                        leg_spread_length / 2,
                        leg_horizontal_length * 1.25
                    ],
                    size2 = [
                        leg_spread_length - leg_spread_length / 5,
                        leg_horizontal_length * 2
                    ],
                    h = leg_vertical_height / 2,
                    orient = DOWN
                );*/
        }
        
        translate([ 0, 20, -1 ])
            difference()
            {
                translate([ 0, 0, -leg_vertical_height ])
                    prismoid(size1 = [ dovetail_horizontal_length, 8 ], size2 = [ leg_spread_length, 8 ], h = leg_vertical_height, orient = FWD);
                
                translate([ 0, -6, -leg_vertical_height - 1 ])
                    prismoid(size1 = [ dovetail_horizontal_length - 8, 12 ], size2 = [ leg_spread_length - 10, 12 ], h = leg_vertical_height - 5, orient = FWD);
            }
            
        translate([ 0, 64 / 2 + 20 + leg_horizontal_length / 4, -leg_vertical_height + 0.5 ])
            difference()
            {
                cyl(d = 64 + 5, h = 8 + 3);
                
                translate([ 0, 0, 3 ])
                    cyl(d = 64, h = 8);
            }
            
        difference()
        {
            translate([ 0, 20, -leg_vertical_height - 1 ])
                prismoid(size1 = [ dovetail_horizontal_length, 8 ], size2 = [ 64 + 5, 8 ], h = (64 / 2 + leg_horizontal_length / 4), orient = BACK);
            
            translate([ 0, 64 / 2 + 20 + leg_horizontal_length / 4, -leg_vertical_height + 0.5 ])
            cyl(d = 64 + 5, h = 8 + 3);
        }
    }
}

// rotate([ 30, 0, 0 ])
    // holder();

// translate([ 0, 0, -64 / 2 ])
    stand();
