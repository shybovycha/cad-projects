include <BOSL2/std.scad>
include <BOSL2/gears.scad>

draw_gear1 = true;
draw_gear2 = false;
draw_gear3 = false;
draw_gear4 = false;
draw_gear5 = false;
draw_gear6 = false;
draw_gear7 = false;
draw_gear8 = false;
draw_gear9 = false;
draw_gear10 = false;
draw_gear11 = false;
draw_gear12 = false;
draw_gear13 = false;
draw_gear14 = false;

draw_perfboard = true;

// perfboard width
perf_width = 100;

// perfboard height
perf_height = 100;

module main()
{
    if (draw_perfboard)
    {
        difference()
        {
            translate([ -10, -10, 0 ])
            cuboid(size = [ perf_width + 15, perf_height + 15, 3 ], anchor = TOP + FRONT + LEFT, chamfer = 1, trimcorners = false);
            
            for ( x = [ 0:15:perf_width ])
                for ( y = [ 0:15:perf_height ])
                    translate([ x, y, 0 ])
                        cyl(d = 5, l = 10, $fn = 32);
        }
    }
    
    if (draw_gear1)
    {
        gear1();
    }

    if (draw_gear2)
    translate([ 0, 50, 0 ])
    {
        difference()
        {
            gear2();

            for ( a = [ 0:(360/6):360 ]) 
            {
                translate([ cos(a) * 15, sin(a) * 15, 0 ])
                    cyl(d = 5, l = 8, $fn = 16);
            }
        }
    }
    
    if (draw_gear3)
    translate([ 75, 0, 0 ])
    {
        gear3();
    }
        
    if (draw_gear4)
    translate([ 75, 50, 0 ])
    {
        difference()
        {
            gear4();

            for ( a = [ 0:(360/6):360 ]) 
            {
                translate([ cos(a) * 15, sin(a) * 15, 0 ])
                    cyl(d = 5, l = 10, $fn = 16);
            }
        }
    }

    if (draw_gear5)
    translate([ 150, 0, 0 ])
    {
        gear5();
    }
        
    if (draw_gear6)
    translate([ 150, 50, 0 ])
    {
        difference()
        {
            gear6();

            for ( a = [ 0:(360/6):360 ]) 
            {
                translate([ cos(a) * 15, sin(a) * 15, 0 ])
                    cyl(d = 5, l = 8, $fn = 16);
            }
        }
    }

    if (draw_gear7)
    translate([ 225, 0, 0 ])
    {
        gear7();
    }

    if (draw_gear8)
    translate([ 225, 50, 0 ])
    {
        gear8();
    }

    if (draw_gear9)
    translate([ 225, 100, 0 ])
    {
        gear9();
    }
        
    if (draw_gear10)
    translate([ 225, 150, 0 ])
    {
        difference()
        {
            gear10();

            for ( a = [ 0:(360/6):360 ]) 
            {
                translate([ cos(a) * 15, sin(a) * 15, 0 ])
                    cyl(d = 5, l = 18, $fn = 16);
            }
        }
    }

    if (draw_gear11)
    translate([ 300, 0, 0 ])
        gear11();
        
    if (draw_gear12)
    translate([ 300, 50, 0 ])
    {
        gear12();
    }
        
    if (draw_gear13)
    translate([ 300, 100, 0 ])
    {
        gear13();
    }
     
    if (draw_gear14)   
    translate([ 300, 150, 0 ])
    {
        difference()
        {
            gear14();

            for ( a = [ 0:(360/6):360 ]) 
            {
                translate([ cos(a) * 15, sin(a) * 15, 0 ])
                    cyl(d = 5, l = 18, $fn = 16);
            }
        }
    }
}

module gear1()
{
    spur_gear(pitch = 5, teeth = 16, thickness = 3, shaft_diam = 5);
}

module gear2()
{
    spur_gear(pitch = 5, teeth = 32, thickness = 3, shaft_diam = 5);
}

module gear3()
{
    bevel_gear(
        pitch = 5, teeth = 16, face_width = 5, shaft_diam = 5,
        pitch_angle = 45, spiral_angle = 0
    );
}

module gear4()
{
    bevel_gear(
            pitch = 5, teeth = 32, face_width = 5, shaft_diam = 5,
            pitch_angle = 45, spiral_angle = 0
        );
}

module gear5()
{
    bevel_gear(
        pitch = 5, teeth = 16, face_width = 5, shaft_diam = 5,
        pitch_angle = 45, spiral_angle = 0, left_handed = true
    );
}

module gear6()
{
    bevel_gear(
        pitch = 5, teeth = 32, face_width = 5, shaft_diam = 5,
        pitch_angle = 45, spiral_angle = 0, left_handed = true
    );
}

module gear7()
{
    union()
    {
        worm(pitch = 5, d = 10, l = 25, $fn = 72, left_handed = true);
        
        cyl(d = 5, l = 40);
    }
}

module gear8()
{
    union()
    {
        worm(pitch = 5, d = 20, l = 25, $fn = 72, left_handed = true);
        
        cyl(d = 10, l = 40);
    }
}

module gear9()
{
    difference()
    {
        worm_gear(pitch = 5, teeth = 16, worm_diam = 10, worm_starts = 1, left_handed = true);
        
        cyl(d = 5, l = 40);
    }
}

module gear10()
{
    difference()
    {
        worm_gear(pitch = 5, teeth = 32, worm_diam = 20, worm_starts = 1, left_handed = true);
        
        cyl(d = 5, l = 40);
    }
}

module gear11()
{
    union()
    {
        worm(pitch = 5, d = 10, l = 25, $fn = 72);
        
        cyl(d = 5, l = 40);
    }
}

module gear12()
{
    union()
    {
        worm(pitch = 5, d = 20, l = 25, $fn = 72);
        
        cyl(d = 10, l = 40);
    }
}

module gear13()
{
    difference()
    {
        worm_gear(pitch = 5, teeth = 16, worm_diam = 10, worm_starts = 1);
        
        cyl(d = 5, l = 40);
    }
}

module gear14()
{
    difference()
    {
        worm_gear(pitch = 5, teeth = 32, worm_diam = 20, worm_starts = 1);
        
        cyl(d = 5, l = 40);
    }
}

// -------
main();
