include <BOSL2/std.scad>;
include <BOSL2/math.scad>;
include <BOSL2/shapes3d.scad>;
include <BOSL2/gears.scad>;
include <BOSL2/walls.scad>;

case_wall_thickness = 1;

case_width = 125;
case_depth = 120;
case_height = 50;

mount_diameter = 5.5;

mount_insert_diameter = mount_diameter * 0.5;

module bottom()
{
    difference()
    {
        union()
        {
            difference()
            {
                cuboid([ 
                        case_width + (2 * case_wall_thickness),
                        case_depth + (2 * case_wall_thickness),
                        case_height + (2 * case_wall_thickness)
                    ],
                    rounding = 5);
                
                cuboid([ 
                        case_width,
                        case_depth,
                        case_height
                    ], rounding = 5);
                
                translate([ 0, 0, (case_height / 2) + case_wall_thickness ])
                    cuboid([ 
                            case_width + (4 * case_wall_thickness),
                            case_depth + (4 * case_wall_thickness),
                            case_height
                        ]);
            }
            
            translate([
                (case_width / 2) - (mount_diameter / 2) + (case_wall_thickness / 4),
                (case_depth / 2) - (mount_diameter / 2) + (case_wall_thickness / 4),
                -(case_height / 4) + (case_wall_thickness * 2)
            ])
                cyl(d = mount_diameter, h = (case_height / 2) - (case_wall_thickness * 2));
            
            translate([
                -(case_width / 2) + (mount_diameter / 2) - (case_wall_thickness / 4),
                (case_depth / 2) - (mount_diameter / 2) + (case_wall_thickness / 4),
                -(case_height / 4) + (case_wall_thickness * 2)
            ])
                cyl(d = mount_diameter, h = (case_height / 2) - (case_wall_thickness * 2));
            
            translate([
                (case_width / 2) - (mount_diameter / 2) + (case_wall_thickness / 4),
                -(case_depth / 2) + (mount_diameter / 2) - (case_wall_thickness / 4),
                -(case_height / 4) + (case_wall_thickness * 2)
            ])
                cyl(d = mount_diameter, h = (case_height / 2) - (case_wall_thickness * 2));
                
            translate([
                -(case_width / 2) + (mount_diameter / 2) - (case_wall_thickness / 4),
                -(case_depth / 2) + (mount_diameter / 2) - (case_wall_thickness / 4),
                -(case_height / 4) + (case_wall_thickness * 2)
            ])
                cyl(d = mount_diameter, h = (case_height / 2) - (case_wall_thickness * 2));
        }
        
        // inserts
        translate([
            (case_width / 2) - (mount_diameter / 2) - (case_wall_thickness / 4) + (mount_insert_diameter / 4),
            (case_depth / 2) - (mount_diameter / 2) - (case_wall_thickness / 4) + (mount_insert_diameter / 4),
            - (case_wall_thickness)
        ])
            cyl(d = mount_insert_diameter, h = case_wall_thickness * 5);
        
        translate([
            -(case_width / 2) + (mount_diameter / 2) + (case_wall_thickness / 4) - (mount_insert_diameter / 4),
            (case_depth / 2) - (mount_diameter / 2) - (case_wall_thickness / 4) + (mount_insert_diameter / 4),
            - (case_wall_thickness)
        ])
            cyl(d = mount_insert_diameter, h = case_wall_thickness * 5);
        
        translate([
            (case_width / 2) - (mount_diameter / 2) - (case_wall_thickness / 4) + (mount_insert_diameter / 4),
            -(case_depth / 2) + (mount_diameter / 2) + (case_wall_thickness / 4) - (mount_insert_diameter / 4),
            - (case_wall_thickness)
        ])
            cyl(d = mount_insert_diameter, h = case_wall_thickness * 5);
            
        translate([
            -(case_width / 2) + (mount_diameter / 2) + (case_wall_thickness / 4) - (mount_insert_diameter / 4),
            -(case_depth / 2) + (mount_diameter / 2) + (case_wall_thickness / 4) - (mount_insert_diameter / 4),
            - (case_wall_thickness)
        ])
            cyl(d = mount_insert_diameter, h = case_wall_thickness * 5);
    }
}

module top()
{
    union()
    {
        difference()
        {
            cuboid([ 
                    case_width + (2 * case_wall_thickness),
                    case_depth + (2 * case_wall_thickness),
                    case_height + (2 * case_wall_thickness)
                ],
                rounding = 5);
            
            cuboid([ 
                    case_width,
                    case_depth,
                    case_height
                ], rounding = 5);
            
            translate([ 0, 0, -(case_height / 2) - case_wall_thickness ])
                cuboid([ 
                        case_width + (4 * case_wall_thickness),
                        case_depth + (4 * case_wall_thickness),
                        case_height
                    ]);
        }
        
        translate([
            (case_width / 2) - (mount_diameter / 2) - case_wall_thickness,
            (case_depth / 2) - (mount_diameter / 2) - case_wall_thickness,
            (case_height / 4) - (case_wall_thickness)
        ])
            cyl(d = mount_diameter, h = (case_height / 2));
        
        translate([
            -(case_width / 2) + (mount_diameter / 2) + case_wall_thickness,
            (case_depth / 2) - (mount_diameter / 2) - case_wall_thickness,
            (case_height / 4) - (case_wall_thickness)
        ])
            cyl(d = mount_diameter, h = (case_height / 2));
        
        translate([
            (case_width / 2) - (mount_diameter / 2) - case_wall_thickness,
            -(case_depth / 2) + (mount_diameter / 2) + case_wall_thickness,
            (case_height / 4) - (case_wall_thickness)
        ])
            cyl(d = mount_diameter, h = (case_height / 2));
            
        translate([
            -(case_width / 2) + (mount_diameter / 2) + case_wall_thickness,
            -(case_depth / 2) + (mount_diameter / 2) + case_wall_thickness,
            (case_height / 4) - (case_wall_thickness)
        ])
            cyl(d = mount_diameter, h = (case_height / 2));
           
        // inserts
        translate([
            (case_width / 2) - (mount_diameter / 2) - case_wall_thickness,
            (case_depth / 2) - (mount_diameter / 2) - case_wall_thickness,
            (case_height / 4) - (case_wall_thickness * 2)
        ])
            cyl(d = mount_insert_diameter, h = (case_height / 2));
        
        translate([
            -(case_width / 2) + (mount_diameter / 2) + case_wall_thickness,
            (case_depth / 2) - (mount_diameter / 2) - case_wall_thickness,
            (case_height / 4) - (case_wall_thickness * 2)
        ])
            cyl(d = mount_insert_diameter, h = (case_height / 2));
        
        translate([
            (case_width / 2) - (mount_diameter / 2) - case_wall_thickness,
            -(case_depth / 2) + (mount_diameter / 2) + case_wall_thickness,
            (case_height / 4) - (case_wall_thickness * 2)
        ])
            cyl(d = mount_insert_diameter, h = (case_height / 2));
            
        translate([
            -(case_width / 2) + (mount_diameter / 2) + case_wall_thickness,
            -(case_depth / 2) + (mount_diameter / 2) + case_wall_thickness,
            (case_height / 4) - (case_wall_thickness * 2)
        ])
            cyl(d = mount_insert_diameter, h = (case_height / 2));
    }
}

// translate([ 0, 0, 60 ])
// top();

bottom();

$fn = 128;
