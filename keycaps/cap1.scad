use <keyv2/key/src/key.scad>;

include <keyv2/key/src/settings.scad>
include <keyv2/key/src/key_sizes.scad>
include <keyv2/key/src/key_profiles.scad>
include <keyv2/key/src/key_types.scad>
include <keyv2/key/src/key_transformations.scad>

$inverted_dish = false;
$key_length = 1;

$dish_type =  "sideways cylindrical";

/*for (y = [0 : 5]) {
    for (x = [0: 4]) {
        translate_u(x, y) 1u() oem_row(1) box_cherry() key();
    }
}*/

$fn = 256;

$font_size = 3;
$key_bump_edge = 3;
$key_bump_depth = -0.25;

1u() oem_row(1) box_cherry() bump() key();
