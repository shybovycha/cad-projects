include <BOSL2/std.scad>;
include <BOSL2/shapes3d.scad>;
include <BOSL2/walls.scad>;
include <BOSL2/drawing.scad>;

difference() {
    union() {
        rotate([ 0, 0, -9.5 ])
            translate([ 48, 78, -0.5 ])
                cuboid(size = [102, 80, 2], rounding = 5, edges=[ LEFT+FRONT, RIGHT+FRONT, LEFT+BACK, RIGHT+BACK], $fn = 32);

        rotate([ 0, 0, -15.5 ])
            translate([ 91, 42, -0.5 ])
                cuboid(size = [45, 26, 2], rounding = 5, edges=[ LEFT+FRONT, RIGHT+FRONT, LEFT+BACK, RIGHT+BACK], $fn = 32);
    }

    linear_extrude(height = 4, center = true, convexity = 10)
        import(file = "cutout4.dxf", layer = "0");
}
