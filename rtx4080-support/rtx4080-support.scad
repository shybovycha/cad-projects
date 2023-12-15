include <BOSL2/std.scad>
include <BOSL2/cubetruss.scad>

union()
{
    difference()
    {
        translate([ 0, -15/2-5, 75/2-1 ])
        {
            fillet(l=6, r=110/2, ang=90);
            
            rotate([ 0, 0, 90 ])
                fillet(l=6, r=110/2, ang=90);
        }
        
        translate([ -50, -10, 75/2 ])
            cuboid([ 30, 10, 12 ]);
        
        translate([ 50, -10, 75/2 ])
            cuboid([ 30, 10, 12 ]);
        
        translate([ 0, 45, 75/2 ])
            cuboid([ 10, 30, 12 ]);
    }
    
    rotate([ -90, 0, 0 ])
        cubetruss(extents=5, size=15, strut=2, bracing=true);
    
    translate([ 0, 0, -75/2+2.6 ])
    {
        cuboid([ 18, 18, 3 ]);
    }
}
