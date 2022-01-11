include <BOSL2/std.scad>
min_slop = 0.00;
slop_step = 0.05;
holes = 8;
holesize = [15,15,15];
height = 20;
gap = 5;
l = holes * (holesize.x + gap) + gap;
w = holesize.y + 2*gap;
h = holesize.z + 5;
diff("holes")
cuboid([l, w, h], anchor=BOT) {
  for (i=[0:holes-1]) {
    right((i-holes/2+0.5)*(holesize.x+gap)) {
      s = min_slop + slop_step * i;
      tags("holes") {
        cuboid([holesize.x + 2*s, holesize.y + 2*s, h+0.2]);
        fwd(w/2-1) xrot(90) linear_extrude(1.1) {
          text(
            text=fmt_fixed(s,2),
            size=0.4*holesize.x,
            halign="center",
            valign="center"
          );
        }
      }
    }
  }
}
back(holesize.y*2.5) {
  difference() {
    union() {
      cuboid([holesize.x+10, holesize.y+10, 15], anchor=BOT);
      cuboid([holesize.x, holesize.y, 15+holesize.z], anchor=BOT);
    }
    up(3) fwd((holesize.y+10)/2) {
      prismoid([holesize.x/2,1], [0,1], h=holesize.y-6);
    }
  }
}
