include <BOSL2/std.scad>;
include <BOSL2/shapes3d.scad>;
include <BOSL2/walls.scad>;
include <BOSL2/drawing.scad>;

// union() {
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
