include <BOSL2/std.scad>
include <BOSL2/threading.scad>

/*
r = sqrt(pow(min(w, h), 2) + pow(max(w, h) / 2, 2))
*/

// largest item' dimensions
w = 20;
h = 25;
l = 97;

cap_l = 20;

r = sqrt(pow(min(w, h), 2) + pow(max(w, h) / 2, 2));

wall = 3;
rounding = 5;

// count for thread
outer_r = r + wall * 1.5;

grip_thickness = wall * 0.5;

thread_l = cap_l * 0.6;

DEBUG = false;

DRAW_BODY = false;
DRAW_CAP = true;

// $fn = 100;

// main body
// if (DEBUG) projection(cut = true)
if (DRAW_BODY)
union() {
    difference() {
        union() {
            // externals
            cyl(l = l + wall + rounding - thread_l, r = outer_r, rounding1 = rounding);
            
            // thread
            translate([ 0, 0, (l / 2) + (thread_l / 2) - wall ]) {
                threaded_rod(d = outer_r * 2, l = thread_l + wall / 2, pitch = 4, end_len1 = wall,  orient = TOP);
            }
        }
        
        // internals
        translate([ 0, 0, wall * 4.5 ])
            cyl(l = l + wall + thread_l, r = r, rounding1 = rounding);
        
        if (DEBUG)
        translate([ r, 0, 0 ])
            cuboid([ (r + wall) * 2, (r + wall) * 3, l * 2 ]);
    }
    
    // inner walls
    translate([ 0, 0, wall ]) {
        cuboid([ outer_r * 2 - wall, wall, l - thread_l + wall / 2 ]);
        
        translate([ 0, r / 2 + wall / 2, 0 ])
        rotate([ 0, 0, 90 ])
            cuboid([ r + wall, wall, l - thread_l + wall / 2 ]);
    }
}

if (DRAW_CAP)
translate([ 0, 0, l + (wall)]) {
    // cap
    difference() {
        union() {
            translate([ 0, 0, wall ])
                cyl(l = cap_l + wall, r = outer_r + grip_thickness, rounding2 = rounding);

            cyl(l = cap_l, r = outer_r + grip_thickness, texture = "diamonds", tex_size = [ 5, 5 ]);
        }
        
        // internals
        translate([ 0, 0, -wall / 2 ]) {
            cyl(l = cap_l + wall, r = r, rounding2 = rounding);
            
            // thread, count for offset
            translate([ 0, 0, -wall ])
                threaded_rod(d = outer_r * 2, l = thread_l + wall / 2, pitch = 4, orient = TOP);
        }
        
        if (DEBUG)
        translate([ (r + wall) * 2, 0, 0 ])
            cuboid([ (r + wall) * 4, (r + wall) * 4, l * 2 ]);
    }
}