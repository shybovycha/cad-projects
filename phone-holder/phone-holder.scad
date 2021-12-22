use <BOSL/threading.scad>;
use <BOSL/shapes.scad>;

module arm(arm_length, arm_width, arm_height, arm_mount_radius)
{
    difference()
    {
        union()
        {
            // cube([ arm_length, arm_width, arm_height ], center = false);
            translate([ arm_length / 2, arm_width / 2, 0 ])
            rotate([ 0, 90, 90 ])
            sparse_strut(l = arm_length, h = arm_width, thick = arm_height, strut = 1);

            translate([ 0, arm_width / 2, 0 ])
                cylinder(arm_height, d = arm_width, center = true);

            translate([ arm_length, arm_width / 2, 0 ])
                cylinder(arm_height, d = arm_width, center = true);
        }

        translate([ 0, arm_width / 2, 0 ])
          cylinder(h = arm_height * 2, r = arm_mount_radius, center = true);

        translate([ arm_length, arm_width / 2, 0 ])
          cylinder(h = arm_height * 2, r = arm_mount_radius, center = true);

        /*for (i = [ 0 : 2 : floor((arm_length - (arm_mount_radius * 4)) / (arm_width / 2)) ])
        {
            translate([ arm_width + (i * arm_mount_radius * 2), arm_width / 2 - arm_mount_radius * 1.8, -arm_height / 2 ])
                rotate([ 0, 0, 45 ])
                    cube([ arm_width / 2, arm_width / 2, arm_height * 2 ], center = false);
        }*/
    }
}

module arm_joint_top(arm_length, arm_width, arm_height, arm_mount_radius, axis_width)
{
    joint_length = (arm_width * 2) + axis_width;
    joint_width = arm_width; // max(arm_width, axis_width) * 1.5;
    // joint_height = ((arm_height * 1.5) + (axis_width * 1.5));
    joint_height = arm_height * 1.5;

    axis_mount_length1 = axis_width * 1.5;
    axis_mount_length2 = axis_mount_length1 * 2;
    axis_mount_width = joint_width;

    axis_thread_pitch = 2;
    thread_radius = (axis_width + axis_thread_pitch / 2) / 2;

    axis_mount_height = thread_radius * 2 * 1.5;

    support_height = max(arm_height, axis_mount_height) + (arm_height / 2);

    // top half
    union()
    {
        cube([
            joint_length,
            joint_width,
            joint_height / 2
        ],
        center = false);

        translate([ 0, arm_width / 2, 0 ])
            cylinder(d = joint_width, h = joint_height / 2, center = false);

        translate([ joint_length, joint_width / 2, 0 ])
            cylinder(d = joint_width, h = joint_height / 2, center = false);

        // supports
        translate([ 0, joint_width / 2, -support_height ])
            cylinder(r = arm_mount_radius, h = support_height, center = false);

        translate([ joint_length, joint_width / 2, -support_height ])
            cylinder(r = arm_mount_radius, h = support_height, center = false);

        // axis mount
        difference()
        {
            translate([ joint_length / 2, joint_width - axis_mount_width / 2, -axis_mount_height ])
                difference()
                {
                    // cube([ axis_width * 1.5, axis_width * 1.5, axis_width * 1.5 ], center = false);
                    prismoid(size1 = [ axis_mount_length1, axis_mount_width ], size2 = [ axis_mount_length2, axis_mount_width ], h = thread_radius * 2 * 1.5, center = false);

                    translate([ 0, -axis_mount_width, axis_mount_height / 2 ])
                        rotate([ 90, 0, 0 ])
                            trapezoidal_threaded_rod(d = thread_radius * 2, l = axis_mount_width * 4, pitch = axis_thread_pitch, thread_angle = 15, internal = true);
                }

            // nicer entrance to the thread
            // translate([ joint_length / 2, arm_height, (axis_mount_height / 2) - axis_mount_height ])
                    // rotate([ 90, 0, 0 ])
                        // cylinder(r = thread_radius, h = arm_height * 1.5);
        }
    }
}

module arm_joint_bottom(arm_length, arm_width, arm_height, arm_mount_radius, axis_width)
{
    joint_length = (arm_width * 2) + axis_width;
    joint_width = arm_width; // max(arm_width, axis_width) * 1.5;
    // joint_height = ((arm_height * 1.5) + (axis_width * 1.5));
    joint_height = arm_height * 1.5;

    // bottom half
    difference()
    {
        union()
        {
            cube([
                joint_length,
                joint_width,
                joint_height / 2
            ],
            center = false);

            translate([ 0, joint_width / 2, 0 ])
                cylinder(d = joint_width, h = joint_height / 2, center = false);

            translate([ joint_length, joint_width / 2, 0 ])
                cylinder(d = joint_width, h = joint_height / 2, center = false);
        }

        // pads for supports
        translate([ 0, joint_width / 2, arm_height / 2 ])
            cylinder(r = arm_mount_radius, h = arm_height * 2, center = false);

        translate([ joint_length, joint_width / 2, arm_height / 2 ])
            cylinder(r = arm_mount_radius, h = arm_height * 2, center = false);
    }
}

module arm_joint_stopper(arm_length, arm_width, arm_height, arm_mount_radius, axis_width)
{
    joint_length = (arm_width * 2) + axis_width;
    joint_width = arm_width; // max(arm_width, axis_width) * 1.5;
    // joint_height = ((arm_height * 1.5) + (axis_width * 1.5));
    joint_height = arm_height * 1.5;

    axis_mount_length1 = axis_width * 1.5;
    axis_mount_length2 = axis_mount_length1 * 2;
    axis_mount_width = joint_width;

    axis_thread_pitch = 2;
    thread_radius = (axis_width + axis_thread_pitch) / 2;

    axis_mount_height = thread_radius * 2 * 1.5;

    support_height = max(arm_height, axis_mount_height);

    // top half
    union()
    {
        cube([
            joint_length,
            joint_width,
            joint_height / 2
        ],
        center = false);

        translate([ 0, arm_width / 2, 0 ])
            cylinder(d = joint_width, h = joint_height / 2, center = false);

        translate([ joint_length, joint_width / 2, 0 ])
            cylinder(d = joint_width, h = joint_height / 2, center = false);

        // supports
        translate([ 0, joint_width / 2, -support_height ])
            cylinder(r = arm_mount_radius, h = support_height, center = false);

        translate([ joint_length, joint_width / 2, -support_height ])
            cylinder(r = arm_mount_radius, h = support_height, center = false);

        // axis mount
        translate([ joint_length / 2, joint_width - axis_mount_width / 2, -axis_mount_height ])
            difference()
            {
                // cube([ axis_width * 1.5, axis_width * 1.5, axis_width * 1.5 ], center = false);

                prismoid(size1 = [ axis_mount_length1, axis_mount_width ], size2 = [ axis_mount_length2, axis_mount_width ], h = thread_radius * 2 * 1.5, center = false);

                translate([ 0, -axis_mount_width, axis_mount_height / 2 ])
                    rotate([ 90, 0, 0 ])
                        cylinder(r = thread_radius, h = axis_mount_width * 1.5, center = true);
            }
    }
}

module joint_axis(arm_length, arm_width, min_spread, max_spread, axis_width, handle_offset_length)
{
    // a^2 + b^2 = c^2
    // c = arm_length
    // b0 = (max_spread / 2)
    // b1 = (min_spread / 2)
    // a0 = sqrt(arm_length^2 - (max_spread / 2)^2)
    // a1 = sqrt(arm_length^2 - (min_spread / 2)^2)
    // total_rod_length = a0 + handle_mount_length
    // thread_length = a1

    c = arm_length;

    b0 = max_spread / 2;
    b1 = min_spread / 2;

    a0 = floor(sqrt(pow(c, 2) - pow(b0, 2)));
    a1 = ceil(sqrt(pow(c, 2) - pow(b1, 2)));

    // total_rod_length = 2 * a1;
    axis_mount_width = arm_width;

    // the min_spread gives longest rod + pad at the stopper + thread length
    non_threaded_part_length = (2 * a0) + (axis_mount_width * 1.5); // + (axis_mount_width);

    threaded_part_length = abs(a0 - a1) * 1.25;

    // echo("c=", c, "b0=", b0, "b1=", b1, "a0=", a0, "a1=", a1, "non-threaded part:", non_threaded_part_length, "; threaded part:", threaded_part_length);

    union()
    {
        translate([ 0, 0, 0 ])
            rotate([ 90, 0, 0 ])
                cylinder(h = non_threaded_part_length, r = (axis_width / 2) * 0.8, center = false);

        translate([ 0, -non_threaded_part_length, 0 ])
            rotate([ 90, 0, 0 ])
                trapezoidal_threaded_rod(d = axis_width, l = threaded_part_length, pitch = 2, thread_angle = 15, center = false);


        translate([ 0, -(non_threaded_part_length + threaded_part_length), 0])
            rotate([ 90, 0, 0 ])
                cylinder(h = handle_offset_length + axis_mount_width, r = (axis_width / 2) * 0.8, center = false);
    }
}

module arm_fastener(arm_width, arm_height, arm_mount_radius)
{
    fastener_head_radius = arm_width / 2;
    fastener_head_height = fastener_head_radius / 2;

    fastener_fixer_height = arm_height;

    fastener_body_radius = arm_mount_radius;
    fastener_body_length = (arm_height * 2) + (fastener_fixer_height * 3);

    fastener_fixer_inner_radius = fastener_body_radius / 2;

    union()
    {
        difference()
        {
            sphere(r = fastener_head_radius);

            translate([ 0, 0, -fastener_head_radius + fastener_head_height ])
                cylinder(r = fastener_head_radius, h = fastener_head_height * 4);
        }

        difference()
        {
            translate([ 0, 0, -fastener_head_radius + fastener_head_height ])
                cylinder(r = fastener_body_radius, h = fastener_body_length);

            translate([ 0, 0, -fastener_head_radius + fastener_head_height + fastener_body_length - (fastener_fixer_height * 2) ])
                difference()
                {
                    cylinder(r = fastener_body_radius * 2, h = fastener_fixer_height);

                    cylinder(r = fastener_fixer_inner_radius, h = fastener_fixer_height);
                }
        }
    }
}

module arm_fastener_fixer(arm_width, arm_height, arm_mount_radius)
{
    fastener_head_radius = arm_width / 2;
    fastener_head_height = fastener_head_radius / 2;

    fastener_fixer_height = arm_height;

    fastener_body_radius = arm_mount_radius;
    fastener_body_length = (arm_height * 2) + (fastener_fixer_height * 3);

    fastener_fixer_inner_radius = fastener_body_radius / 2;

    fastener_fixer_outer_radius = fastener_body_radius * 2;

    translate([ 0, 0, -fastener_head_radius + fastener_head_height + fastener_body_length - (fastener_fixer_height * 2) ])
        difference()
        {
            cylinder(r = fastener_fixer_outer_radius, h = fastener_fixer_height);

            translate([ 0, 0, -fastener_fixer_height / 2 ])
                cylinder(r = fastener_fixer_inner_radius, h = fastener_fixer_height * 2);

            translate([ 0, 0, fastener_fixer_height ])
                rotate([ 90, 0, 0 ])
                    prismoid(size1 = [ fastener_fixer_inner_radius * 1.25, fastener_fixer_height * 3 ], size2 = [fastener_fixer_inner_radius * 2, fastener_fixer_height * 3 ], h = fastener_fixer_outer_radius);
        }
}

module main()
{
    $fn = 32;

    arm_length = 80;
    arm_width = 15;
    arm_height = 2.5;
    arm_mount_radius = 3;

    axis_width = 5;

    min_spread = 80;
    max_spread = 130;

    handle_offset_length = 25;

    for (i = [ 0 : 3 ])
    translate([ -arm_length * 1.5, -arm_width * 2 * i, 0 ])
      //rotate([ 0, 0, 15 ])
      {
        arm(arm_length, arm_width, arm_height, arm_mount_radius);
      }

    {
        translate([ 0, -arm_width, arm_height * 2 ])
        rotate([ 180, 0, 0 ])
        arm_joint_top(arm_length, arm_width, arm_height, arm_mount_radius, axis_width);

        arm_joint_bottom(arm_length, arm_width, arm_height, arm_mount_radius, axis_width);
    }

    translate([ 0, 4 * -arm_width, 0])
    {
        translate([ 0, -arm_width, arm_height * 2 ])
        rotate([ 180, 0, 0 ])
        arm_joint_stopper(arm_length, arm_width, arm_height, arm_mount_radius, axis_width);

        arm_joint_bottom(arm_length, arm_width, arm_height, arm_mount_radius, axis_width);
    }

    translate([ arm_length * 2 / 3, 0, axis_width / 2 ])
    joint_axis(arm_length, arm_width, min_spread, max_spread, axis_width, handle_offset_length);

    for (i = [ 0 : 1 ])
        translate([ -arm_width * (i + 1) * 2, arm_width * 2, 0 ])
            rotate([ 90, 0, 0 ])
                arm_fastener(arm_width, arm_height, arm_mount_radius);

    for (i = [ 0 : 1 ])
        translate([ -arm_width * (i + 1) * 2, arm_width * 4, 0 ])
            //rotate([ 90, 0, 0 ])
                arm_fastener_fixer(arm_width, arm_height, arm_mount_radius);

    //translate([ 0, -arm_width, arm_height * 2 ])
        // rotate([ 180, 0, 0 ])
            // arm_joint_top(arm_length, arm_width, arm_height, arm_mount_radius, axis_width);

    // joint_axis(arm_length, arm_width, min_spread, max_spread, axis_width, handle_offset_length);

    //translate([ -arm_length, 0, arm_height * 2])
      //rotate([ 0, 0, -15 ])
        //arm(arm_length, arm_width, arm_height, arm_mount_radius);

    //translate([ arm_length, 0, arm_height * 2])
      //rotate([ 0, 0, 180 + 15 ])
        //arm(arm_length, arm_width, arm_height, arm_mount_radius);

    //translate([ arm_length, 0, arm_height * 2])
      //rotate([ 0, 0, 180 - 15 ])
        //arm(arm_length, arm_width, arm_height, arm_mount_radius);
}

main();
