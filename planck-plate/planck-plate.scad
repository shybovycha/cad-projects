include <BOSL2/std.scad>;
include <BOSL2/shapes3d.scad>;
include <BOSL2/walls.scad>;
include <BOSL2/drawing.scad>;

module plate()
{
    union() {
        difference() {
            translate([ -3, -3, -1.25 ])
                cuboid(
                    size = [ 228 + 6, 76 + 6, 2.5 ],
                    anchor = FRONT + BOTTOM + LEFT,
                    chamfer = 1,
                    trimcorners = true
                );
            
            translate([ 2, 0.5, -1.5 ])
                cuboid(
                    size = [ 226, 75, 5 ],
                    anchor = FRONT + BOTTOM + LEFT
                );
        }

        linear_extrude(height = 2.5, center = true)
            import(file = "cutout1.dxf", layer = "0");

        translate([ 114.5, 76.4, 0 ])
            prismoid(
                size1 = [ 65 + 10, 2 ],
                size2 = [ 65, 2 ],
                h = 25,
                orient = BACK
            );
    }
}

module base()
{
    difference()
    {
        translate([ -3 - 3, -3 - 3, 2.5 ])
            cuboid(
                size = [ 228 + 6 + 6, 76 + 6 + 6, 25 ],
                anchor = FRONT + BOTTOM + LEFT,
                chamfer = 1,
                trimcorners = true
            );
        
        translate([ -3, -3, 2.5 + 3 ])
            cuboid(
                size = [ 228 + 6, 76 + 6, 25 ],
                anchor = FRONT + BOTTOM + LEFT,
                chamfer = 1,
                trimcorners = true
            );
        
        translate([ 114.5, 76.4, 2.5 + 25 - 2.4 ])
            cuboid(
                size = [ 65 + 10, 25, 2 + 3 ]
            );
    }
}

module base2()
{
    union()
    {
        difference()
        {
            translate([ -3 - 3, -3 - 3, 2.5 ])
                cuboid(
                    size = [ 228 + 6 + 6, 76 + 6 + 6, 15 ],
                    anchor = FRONT + BOTTOM + LEFT,
                    chamfer = 1,
                    trimcorners = true
                );
            
            translate([ -3, -3, 2.5 + 3 ])
                cuboid(
                    size = [ 228 + 6, 76 + 6, 15 ],
                    anchor = FRONT + BOTTOM + LEFT,
                    chamfer = 1,
                    trimcorners = true
                );
        }
        
        difference()
        {
            translate([ -3, -3, 25 - 20 ])
                cuboid(
                    size = [ 228 + 6 + 1.5, 76 + 6 + 1.5, 10 ],
                    anchor = FRONT + BOTTOM + LEFT
                );
            
            translate([ 0, 0, 25 - 15 - 4 ])
                cuboid(
                    size = [ 228, 76, 15 + 1 ],
                    anchor = FRONT + BOTTOM + LEFT
                );
        }
        
        color([ 0, 0.5, 0 ])
        translate([ 228/2, 76 + 3, -2.5 ])
            prismoid(
                size1 = [ 228, 0 ],
                size2 = [ 228, 76 ],
                shift = [ 0, -76/2 ],
                h = 5
            );
    }
}

module base2_left_half()
{
    difference()
    {
        base2();
        
        color([ 1.0, 0.1, 0.1 ])
            translate([ 114.5 - 65/2 - 5, -9, -5 ])
                cuboid(
                    size = [ 165 + 10, 76 + 8 + 10, 25 + 15 ],
                    anchor = FRONT + BOTTOM + LEFT
                );
    }
}

module base2_right_half()
{
    difference()
    {
        base2();
        
        color([ 1.0, 0.1, 0.1 ])
            translate([ -65/2 + 5 + 5, -9, -5 ])
                cuboid(
                    size = [ 165 + 10, 76 + 8 + 10, 25 + 15 ],
                    anchor = FRONT + BOTTOM + LEFT
                );
    }
}

// base2_left_half();

base2_right_half();

/*
color([ 0, 0, 0.7 ])
translate([ 0, 0, 25 + 1 ])
plate();
*/
