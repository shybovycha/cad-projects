difference() {
    union() {
        translate([ 3, 45, -1.5 ])
            rotate([ 0, 0, -10 ])
                cube(size = [105, 75, 2]);
        
        translate([ 73, 7, -1.5 ])
            rotate([ 0, 0, -15 ])
                cube(size = [45, 35, 2]);
    }
    
    linear_extrude(height = 4, center = true, convexity = 10)
        import(file = "cutout4.dxf", layer = "0");
}
