pump_radius = 50;

pistons = 6;

shaft_radius = 10;
barrel_height = 50;

barrel_wall_thickness = 5;

piston_gaskets = 1;
gasket_radius = 1;
piston_mount_radius = 1;

connector_length = 30;

swashplate_angle = 10;

intake_port_height = 15;

// functional variables

port_plate_height = barrel_wall_thickness;
swashplate_height = barrel_wall_thickness;

piston_height = barrel_height / 4;

piston_radius = (pump_radius - (barrel_wall_thickness * 2) - shaft_radius) / 3;
piston_center_offset = (pump_radius - piston_radius - barrel_wall_thickness);

pump_height = barrel_height + swashplate_height + (pump_radius * cos(swashplate_angle)) + connector_length;

intake_port_radius = piston_radius;

module barrel() {
    difference() {
        // chamber body
        cylinder(barrel_height, pump_radius, pump_radius);
        
        // holes for pistons
        for (i = [ 0 : (360 / pistons) : 360 ]) {
            translate([ piston_center_offset * cos(i), piston_center_offset * sin(i), barrel_wall_thickness * -1 ])
                cylinder(barrel_height + (barrel_wall_thickness * 2), piston_radius + (gasket_radius / 3), piston_radius + (gasket_radius / 3));
        }
    }
}

module port_plate() {
    difference() {
        cylinder(port_plate_height, pump_radius, pump_radius);

        rotate_extrude(angle = 120) {
            translate([ piston_center_offset * cos(0), piston_center_offset * sin(0), 0])
                square(piston_radius * 1.75, center = true);
        }
    
        rotate_extrude(angle = 120) {
            translate([ piston_center_offset * cos(180), piston_center_offset * sin(180), 0])
                square(piston_radius * 1.75, center = true);
        }
    
        translate([ piston_center_offset * cos(120), piston_center_offset * sin(120), -(port_plate_height / 2) ])
            cylinder(h = port_plate_height * 2, r = piston_radius - 1);
    
        translate([ piston_center_offset * cos(0), piston_center_offset * sin(0), -(port_plate_height / 2) ])
            cylinder(h = port_plate_height * 2, r = piston_radius - 1);
    
        translate([ piston_center_offset * cos(180 + 120), piston_center_offset * sin(180 + 120), -(port_plate_height / 2) ])
            cylinder(h = port_plate_height * 2, r = piston_radius - 1);
    
        translate([ piston_center_offset * cos(180), piston_center_offset * sin(180), -(port_plate_height / 2) ])
            cylinder(h = port_plate_height * 2, r = piston_radius - 1);
    }
}

module piston_mount() {
    hole_radius = piston_mount_radius;
    hole_barrel_wall_thickness = hole_radius * 2;
    
    mount_width = (hole_barrel_wall_thickness * 2) + hole_radius;
    mount_height = mount_width + hole_barrel_wall_thickness;
    
    mount_gap = mount_height - mount_width;

    // mount
    difference() {
        union() {
            cube([ mount_width, mount_width, mount_height ], center = true);

            translate([ 0, 0, -((mount_width / 2) + hole_radius) ]) rotate([ 90, 0, 0 ])
                    cylinder(h = mount_width, r = (mount_width / 2), center = true);
        }
        
        translate([ 0, 0, -((mount_width / 2) + hole_radius) ]) rotate([ 90, 0, 0 ])
            cylinder(h = mount_gap, r = mount_height / 2, center = true);
        
        translate([ 0, 0, -((mount_width / 2) + hole_radius) ]) rotate([ 90, 0, 0 ])
            cylinder(h = mount_height, r = hole_radius, center = true);
    }
}

module piston_connector() {
    hole_radius = piston_mount_radius;
    hole_barrel_wall_thickness = hole_radius * 2;
    
    mount_width = (hole_barrel_wall_thickness * 2) + hole_radius;
    mount_height = mount_width + hole_barrel_wall_thickness;
    
    connector_width = mount_height - mount_width;
    
    difference() {
        union() {
            translate([ 0, 0, -(mount_height / 2) ]) rotate([ 90, 0, 0 ]) 
                cylinder(h = connector_width, r = mount_height / 2, center = true);
            
            translate([ 0, 0, -(connector_length + mount_height) / 2 ])
                cube([ mount_height, connector_width, connector_length ], center = true);
            
            translate([ 0, 0, -(connector_length + (mount_height / 2)) ]) rotate([ 90, 0, 0 ])
                sphere(r = mount_height);
        }
        
        translate([ 0, 0, -(mount_height / 2) ]) rotate([ 90, 0, 0 ]) 
            cylinder(h = connector_width * 2, r = hole_radius, center = true);
    }
}

module piston() {
    difference() {
        cylinder(piston_height, piston_radius, piston_radius);
        
        // grooves for gaskets
        if (piston_gaskets > 0) {
            groove_barrel_wall_thickness = piston_height / (piston_gaskets + 1);
        
            for (i = [ 1 : piston_gaskets ]) {
                translate([ 0, 0, groove_barrel_wall_thickness * i ])
                    rotate_extrude() {
                        translate([ piston_radius, 0, 0 ])
                            circle(r = gasket_radius);
                    }
            }
        }
    }

    piston_mount();
    
    piston_connector();
}

module pistons() {
    for (i = [ 0 : (360 / pistons) : 360 ]) {
        translate([ piston_center_offset * cos(i), piston_center_offset * sin(i), -barrel_wall_thickness * cos(i) ])
            rotate([ 0, 0, i ])
                piston();
    }
}

module case() {
    difference() {
        translate([ 0, 0, -pump_height ]) cylinder(h = pump_height, r = pump_radius + barrel_wall_thickness);
        
        translate([ 0, 0, -pump_height * 1.5 ]) cylinder(h = pump_height * 2, r = pump_radius);
    }
}

module swashplate() {
    hole_radius = piston_mount_radius;
    hole_barrel_wall_thickness = hole_radius * 2;
    
    mount_width = (hole_barrel_wall_thickness * 2) + hole_radius;
    mount_height = mount_width + hole_barrel_wall_thickness;
    
    connector_width = mount_height - mount_width;

    rotate([ swashplate_angle, 0, 0 ])
        difference() {
            cylinder(h = swashplate_height, r = pump_radius);
        
            for (i = [ 0 : (360 / pistons) : 360 ]) {
                translate([ piston_center_offset * cos(i), piston_center_offset * sin(i), -swashplate_height / 2 ])
                    cylinder(h = swashplate_height * 2, r = mount_height * 0.75);
            }
        }
}

module intake_cap() {
    difference() {
        union() {
            cylinder(h = barrel_wall_thickness, r = pump_radius + barrel_wall_thickness);
    
            translate([ piston_center_offset * cos(0), piston_center_offset * sin(0), barrel_wall_thickness])
                cylinder(h = barrel_wall_thickness + intake_port_height, r = intake_port_radius + barrel_wall_thickness);
            
            translate([ piston_center_offset * cos(180), piston_center_offset * sin(180), barrel_wall_thickness])
                cylinder(h = barrel_wall_thickness + intake_port_height, r = intake_port_radius + barrel_wall_thickness);
        }
        
        translate([ piston_center_offset * cos(0), piston_center_offset * sin(0), -(barrel_wall_thickness + intake_port_height) ])
            cylinder(h = (barrel_wall_thickness + intake_port_height) * 3, r = intake_port_radius);
        
        translate([ piston_center_offset * cos(180), piston_center_offset * sin(180), -(barrel_wall_thickness + intake_port_height) ])
            cylinder(h = (barrel_wall_thickness + intake_port_height) * 3, r = intake_port_radius);
    }
}

module pump() {
    translate([ 0, 0, barrel_height ]) barrel();

    translate([ 0, 0, (barrel_height + barrel_wall_thickness) * 2 ]) 
        union() {
            translate([ 0, 0, barrel_wall_thickness ])
                intake_cap();
            
            port_plate();
        }
    
    translate([ 0, 0, piston_height * 2 ]) pistons();
    
    translate([ 0, 0, -swashplate_height + (connector_length * 0.25) ]) swashplate();
    
    translate([ 0, 0, -pump_height / 3 ]) case();
}

pump();
