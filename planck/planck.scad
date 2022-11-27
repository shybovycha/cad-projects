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
            
            translate([ -3 - 0.25/2, -3, 2.5 + 1.5 + 10 ])
                cuboid(
                    size = [ 228 + 6.275, 76 + 6.2, 5 ],
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
    union()
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
        
        translate([ 76, -3, 5 + 4 ])
            prismoid(
                size1 = [ 10, 3 ],
                size2 = [ 10, 4 ],
                h = 4,
                orient = RIGHT
            );
        
        translate([ 76, 79, 5 + 4 ])
            prismoid(
                size1 = [ 10, 3 ],
                size2 = [ 10, 4 ],
                h = 4,
                orient = RIGHT
            );
    }
}

module base2_right_half()
{
    union()
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
        
        translate([ 76 + 77, -3, 5 + 4 ])
            prismoid(
                size1 = [ 10, 3 ],
                size2 = [ 10, 4 ],
                h = 4,
                orient = LEFT
            );
        
        translate([ 76 + 77, 79, 5 + 4 ])
            prismoid(
                size1 = [ 10, 3 ],
                size2 = [ 10, 4 ],
                h = 4,
                orient = LEFT
            );
    }
}

module base2_middle_section()
{
    translate([ -0.75, 0, 0 ])
    {
        difference()
        {
            intersection()
            {
                base2();
                
                translate([ 115.5, 40, 5 ])
                    cuboid(size = [ 75, 105, 25 ]);
            }
            
            // left dovetail grooves
            translate([ 76.75, -3, 4.05 ])
                prismoid(
                    size1 = [ 20, 3.2 ],
                    size2 = [ 20, 4.2 ],
                    h = 4.1,
                    orient = RIGHT
                );
            
            translate([ 76.75, 79, 4.05 ])
                prismoid(
                    size1 = [ 20, 3.2 ],
                    size2 = [ 20, 4.2 ],
                    h = 4.1,
                    orient = RIGHT
                );
            
            // right dovetail grooves
            translate([ 76 + 78.01 - 0.25, -3, 4.05 ])
                prismoid(
                    size1 = [ 20, 3.2 ],
                    size2 = [ 20, 4.2 ],
                    h = 4.11,
                    orient = LEFT
                );
            
            translate([ 76 + 78.01 - 0.25, 79, 4.05 ])
                prismoid(
                    size1 = [ 20, 3.2 ],
                    size2 = [ 20, 4.2 ],
                    h = 4.11,
                    orient = LEFT
                );
            
            // padding for PCB
            translate([ 115 + 0.25, 76.4, 16.5 ])
                cuboid(
                    size = [ 65, 5 + 9, 25 ],
                    orient = BACK
                );
        }
    }
}

// base2_left_half();

// base2_right_half();

base2_middle_section();

// translate([ 0, 0, 15 ])
// plate();
