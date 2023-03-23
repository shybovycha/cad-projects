include <BOSL2/std.scad>;
include <BOSL2/math.scad>;
include <BOSL2/shapes3d.scad>;
include <BOSL2/gears.scad>;
include <BOSL2/walls.scad>;

RENDER_BOTTOM = false;
RENDER_TOP = false;
RENDER_FRONT_PANEL = false;
RENDER_BACK_PANEL = false;

WALL_THICKNESS = 2;

CASE_WIDTH = 140;
CASE_DEPTH = 130;
CASE_HEIGHT = 60;

// half
module half_case() {
    difference() {
        cuboid([ CASE_WIDTH, CASE_DEPTH, CASE_HEIGHT ], rounding = 2, $fn = 64);
        
        // split it in half
        translate([ 0, 0, CASE_HEIGHT / 2 ])
            cuboid([ CASE_WIDTH + 10, CASE_DEPTH + 10, CASE_HEIGHT ]);
        
        // cut out insides
        cuboid([ CASE_WIDTH - WALL_THICKNESS * 2, CASE_DEPTH - 6 * WALL_THICKNESS, CASE_HEIGHT - WALL_THICKNESS ], rounding = 2, $fn = 64);
        
        // cut out for the grooves for the front and back panels
        translate([ 0, 0, WALL_THICKNESS ])
            cuboid([ CASE_WIDTH - 6 * WALL_THICKNESS, CASE_DEPTH + 20, CASE_HEIGHT - 6 * WALL_THICKNESS ], rounding = 2, $fn = 64);
        
        // cut out the grooves themselves
        // front
        translate([ 0, CASE_DEPTH / 2 - 1.5 * WALL_THICKNESS, WALL_THICKNESS ])
            cuboid([ CASE_WIDTH - 2 * WALL_THICKNESS, WALL_THICKNESS * 1.25 + 0.3, CASE_HEIGHT - 2 * WALL_THICKNESS ], rounding = 0, $fn = 64);
        
        // back
        translate([ 0, -CASE_DEPTH / 2 + 1.5 * WALL_THICKNESS, WALL_THICKNESS ])
            cuboid([ CASE_WIDTH - 2 * WALL_THICKNESS, WALL_THICKNESS * 1.25 + 0.3, CASE_HEIGHT - 2 * WALL_THICKNESS ], rounding = 0, $fn = 64);
    }
}

module panel() {
    cuboid([ CASE_WIDTH - 2 * WALL_THICKNESS, WALL_THICKNESS, CASE_HEIGHT - 2 * WALL_THICKNESS ], rounding = 1, $fn = 64);
}

// bottom half
if (RENDER_BOTTOM) {
    union() {
        half_case();
        
        // stands for the main voltage converter
        translate([ -98 / 2 - 1.5, 0.5 * CASE_DEPTH - 6 * WALL_THICKNESS - 33 - 5 - 5 + 7, -CASE_HEIGHT / 2 + WALL_THICKNESS / 2 ])
        difference() {
            cylinder(h = 2 * WALL_THICKNESS, d = 4 + WALL_THICKNESS * 2, $fn = 64);
            
            translate([ 0, 0, WALL_THICKNESS + 0.1 ])
            cylinder(h = WALL_THICKNESS, d = 4, $fn = 64);
        }
        
        translate([ 98 / 2, 0.5 * CASE_DEPTH - 6 * WALL_THICKNESS - 33 - 5 - 5 + 7, -CASE_HEIGHT / 2 + WALL_THICKNESS / 2 ])
        difference() {
            cylinder(h = 2 * WALL_THICKNESS, d = 4 + WALL_THICKNESS * 2, $fn = 64);
            
            translate([ 0, 0, WALL_THICKNESS + 0.1 ])
            cylinder(h = WALL_THICKNESS, d = 4, $fn = 64);
        }
        
        translate([ -98 / 2 - 1.5, 0.5 * CASE_DEPTH - 6 * WALL_THICKNESS - 34 - 5 - 5 - 47 + 7, -CASE_HEIGHT / 2 + WALL_THICKNESS / 2 ])
        difference() {
            cylinder(h = 2 * WALL_THICKNESS, d = 4 + WALL_THICKNESS * 2, $fn = 64);
            
            translate([ 0, 0, WALL_THICKNESS + 0.1 ])
            cylinder(h = WALL_THICKNESS, d = 4, $fn = 64);
        }
        
        translate([ 98 / 2, 0.5 * CASE_DEPTH - 6 * WALL_THICKNESS - 34 - 5 - 5 - 47 + 7, -CASE_HEIGHT / 2 + WALL_THICKNESS / 2 ])
        difference() {
            cylinder(h = 2 * WALL_THICKNESS, d = 4 + WALL_THICKNESS * 2, $fn = 64);
            
            translate([ 0, 0, WALL_THICKNESS + 0.1 ])
            cylinder(h = WALL_THICKNESS, d = 4, $fn = 64);
        }
    }
}

// top half
if (RENDER_TOP) {
    translate([ 1.25 * CASE_WIDTH, 0, 0 ])
        half_case();
}

// front panel
if (RENDER_FRONT_PANEL) {
    color([ 0.7, 0.2, 0.2 ])
        translate([ 0, -0.75 * CASE_DEPTH, WALL_THICKNESS ])
            difference() {
                panel();
                
                // cutout for the indicator
                translate([ -0.5 * CASE_WIDTH + 46, 0, 0 ])
                    cube([ 46, 2 * WALL_THICKNESS, 27 ], center = true);
                
                // cutout for the output
                translate([ -0.5 * CASE_WIDTH + 46 * 1.5 + 15, 0, 0 ])
                    rotate([ 90, 0, 0 ])
                        cylinder(d = 5.15, h = 2 * WALL_THICKNESS, center = true, $fn = 64);
                
                translate([ -0.5 * CASE_WIDTH + 46 * 1.5 + 15 + 18.5, 0, 0 ])
                    rotate([ 90, 0, 0 ])
                        cylinder(d = 5.15, h = 2 * WALL_THICKNESS, center = true, $fn = 64);
                
                // cutout for the adjustment knobs
                translate([ -0.5 * CASE_WIDTH + 46 * 1.5 + 20 + 14 + 20, 0, 10 ])
                    rotate([ 90, 0, 0 ])
                        cylinder(d = 10.05, h = 2 * WALL_THICKNESS, center = true, $fn = 64);
                
                translate([ -0.5 * CASE_WIDTH + 46 * 1.5 + 20 + 14 + 20, 0, -10 ])
                    rotate([ 90, 0, 0 ])
                        cylinder(d = 7.05, h = 2 * WALL_THICKNESS, center = true, $fn = 64);
        }
}

// back panel
if (RENDER_BACK_PANEL) {
    color([ 0.2, 0.2, 0.7 ])
        translate([ 0, 0.75 * CASE_DEPTH, WALL_THICKNESS ])
            union() {
                difference() {
                    panel();
                    
                    // cutout for the power input
                    translate([ CASE_WIDTH / 2 - 50 / 2 - 10, 0, 0 ])
                        cube([ 47.5, 2 * WALL_THICKNESS, 27.6 ], center = true);
                }
                
                // stands for the boost-buck converter
                translate([ 0, 1, (26 / 2) ])
                    rotate([ 90, 0, 0 ])
                        difference() {
                            cylinder(h = 2 * WALL_THICKNESS, d = 4 + WALL_THICKNESS * 2, $fn = 64);
            
                            translate([ 0, 0, WALL_THICKNESS + 0.1 ])
                                cylinder(h = WALL_THICKNESS, d = 4, $fn = 64);
                        }
                        
                translate([ 0, 1, -(26 / 2) ])
                    rotate([ 90, 0, 0 ])
                        difference() {
                            cylinder(h = 2 * WALL_THICKNESS, d = 4 + WALL_THICKNESS * 2, $fn = 64);
            
                            translate([ 0, 0, WALL_THICKNESS + 0.1 ])
                                cylinder(h = WALL_THICKNESS, d = 4, $fn = 64);
                        }
                        
                translate([ -58, 1, (26 / 2) ])
                    rotate([ 90, 0, 0 ])
                        difference() {
                            cylinder(h = 2 * WALL_THICKNESS, d = 4 + WALL_THICKNESS * 2, $fn = 64);
            
                            translate([ 0, 0, WALL_THICKNESS + 0.1 ])
                                cylinder(h = WALL_THICKNESS, d = 4, $fn = 64);
                        }
                        
                translate([ -58, 1, -(26 / 2) ])
                    rotate([ 90, 0, 0 ])
                        difference() {
                            cylinder(h = 2 * WALL_THICKNESS, d = 4 + WALL_THICKNESS * 2, $fn = 64);
            
                            translate([ 0, 0, WALL_THICKNESS + 0.1 ])
                                cylinder(h = WALL_THICKNESS, d = 4, $fn = 64);
                        }
            }
}
