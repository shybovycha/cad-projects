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
    dovetail_incline_angle = 30; // degrees, around x axis
    dovetail_length = 20; // mm, along y axis
    
    back_legs_spread_angle = 15; // degrees, around y axis
    
    stem_height = 65;
    
    dovetail_vertical_height = dovetail_length * sin(dovetail_incline_angle);
    dovetail_horizontal_length = dovetail_length * cos(dovetail_incline_angle);
    
    leg_length = stem_height / cos(dovetail_incline_angle);
    leg_vertical_height = leg_length * cos(dovetail_incline_angle);
    leg_horizontal_length = leg_length * sin(dovetail_incline_angle);
    
    stem_offset = dovetail_vertical_height / 4;
    
    leg_offset = 8 / cos(back_legs_spread_angle);
    
    union()
    {
        // dovetail
        translate([ 0, -4, 0 ])
            rotate([ dovetail_incline_angle, 0, 0 ])
                prismoid(size1 = [ 8, dovetail_length ], size2 = [ 12, dovetail_length ], h = 4);
        
        // stem
        translate([ 0, -(dovetail_horizontal_length / 2) - 4, -(stem_height / 2) + (dovetail_vertical_height / 2) + stem_offset - 8 ])
            rotate([ 0, -90, -90 ])
                prismoid(size1 = [ stem_height - stem_offset * 2, 8 ], size2 = [ stem_height - stem_offset * 2 + (dovetail_vertical_height / 2), 8 ], shift = [ stem_offset, 0 ], h = 8);
        
        // legs
        difference()
        {
            translate([ 0, (leg_horizontal_length / 2) - (dovetail_horizontal_length / 2) + (stem_offset * 2), -(leg_vertical_height / 2) + (dovetail_vertical_height / 2) ])
            {
                translate([ (leg_vertical_height / 2) * sin(back_legs_spread_angle), 0, 0 ])
                    rotate([ dovetail_incline_angle, -back_legs_spread_angle, 0 ])
                        cuboid([ 8, 8, leg_length ]);
            }
            
            
            /*// second leg as a mask
            translate([ 0, (leg_horizontal_length / 2) - (dovetail_horizontal_length / 2) + (stem_offset * 2), -(leg_vertical_height / 2) + (dovetail_vertical_height / 2) ])
            {
                translate([ -(leg_vertical_height / 2) * sin(back_legs_spread_angle), 0, 4 / 2 ])
                    rotate([ dovetail_incline_angle, back_legs_spread_angle, 0 ])
                        cuboid([ 8 + 4, 8 + 4, leg_length + 4 ]);
            }*/
            
            
            // translate([ -(8 + 4) / 2, 0, -leg_vertical_height / 2 + dovetail_vertical_height ])
                // cuboid([ 8 + 4, 8 + 4, leg_vertical_height ]);
            
            // dovetail as a mask
            translate([ 0, -4, 0 ])
                rotate([ dovetail_incline_angle, 0, 0 ])
                    prismoid(size1 = [ 8 + 4, dovetail_length ], size2 = [ 12 + 4, dovetail_length ], h = 4 + 4);
            
            //translate([ 0, -8 - 2, 0 ])
                //rotate([ dovetail_incline_angle, back_legs_spread_angle, 0 ])
                    //cuboid([ 8, 8, leg_length / 2 ]);
        }
        
        difference()
        {
            translate([ 0, (leg_horizontal_length / 2) - (dovetail_horizontal_length / 2) + (stem_offset * 2), -(leg_vertical_height / 2) + (dovetail_vertical_height / 2) ])
            {
                translate([ -(leg_vertical_height / 2) * sin(back_legs_spread_angle), 0, 0 ])
                    rotate([ dovetail_incline_angle, back_legs_spread_angle, 0 ])
                        cuboid([ 8, 8, leg_length ]);
            }
            
            /*// first leg as a mask
            translate([ 0, (leg_horizontal_length / 2) - (dovetail_horizontal_length / 2) + (stem_offset * 2), -(leg_vertical_height / 2) + (dovetail_vertical_height / 2) ])
            {
                translate([ (leg_vertical_height / 2) * sin(back_legs_spread_angle), 0, 4 ])
                    rotate([ dovetail_incline_angle, -back_legs_spread_angle, 0 ])
                        cuboid([ 8 + 4, 8 + 4, leg_length + 4 ]);
            }*/
            
            // dovetail as a mask
            translate([ 0, -4, 0 ])
                rotate([ dovetail_incline_angle, 0, 0 ])
                    prismoid(size1 = [ 8 + 4, dovetail_length ], size2 = [ 12 + 4, dovetail_length ], h = 4 + 4);
        }
        
        // joint
        // translate([ 0, -4, 0 ])
            // rotate([ 0, 180, -90 ])
                // prismoid(size1 = [ (dovetail_horizontal_length / 2) - 4, 8 ], size2 = [ leg_horizontal_length - 4 - 16, 8 ], shift = [ leg_horizontal_length / 4 - 8, 0 ], h = leg_vertical_height / 4);
    }
}

// rotate([ 30, 0, 0 ])
    // holder();

// translate([ 0, 0, -64 / 2 ])
    stand();
