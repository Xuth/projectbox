use <../lib/struct.scad>;

module roundedCuboid(xs,ys,zs,radius) {
    r = max(radius, 0.01);
	    
    hull() {
	for (x = [r, xs-r]) {
	    for (y = [r, ys-r]) {
		for (z = [r, zs-r]) {
		    translate([x,y,z]) sphere(r);
		}
	    }
	}
    }
}

module roundedEdge(xs, ys, zs, radius) {
    hull() {
	for (x = [radius, xs-radius]) {
	    for (y = [radius, ys-radius]) {
		translate([x,y,0]) cylinder(r=radius, h=zs);
	    }
	}
    }
}


module baseRoundedBox(boxDef) {
    x = v(boxDef, "x");
    y = v(boxDef, "y");
    z = v(boxDef, "lidZ");
    radius = v(boxDef, "radius");
    wall = v(boxDef, "wall");
    
    extraHeight = radius * 2;
    difference() {
	roundedCuboid(x,y,z+extraHeight, radius);
	translate([wall, wall, wall]) {
	    roundedCuboid(x-wall*2, y-wall*2, z-wall*2 + extraHeight, radius-wall);
	}
	translate([-1,-1, z]) {
	    cube([x+2, y+2, extraHeight+1]);
	}
    }
}

module baseRoundedBoxLid(boxDef) {
    x = v(boxDef, "x");
    y = v(boxDef, "y");
    lidZ = v(boxDef, "lidZ");
    z = v(boxDef, "z") - lidZ;
    radius = v(boxDef, "radius");
    wall = v(boxDef, "wall");
    lipHeight = v(boxDef, "lipHeight");
    lipWidth = v(boxDef, "lipWidth");
    lipGap = v(boxDef, "lipGap");
    

    extraDepth = radius * 2 + lipHeight;
    wallLip = wall+lipWidth+lipGap;

    translate([0,0,lidZ]) {
	difference() {
	    translate([0,0,-extraDepth]) {
		roundedCuboid(x,y,z+extraDepth, radius);
	    }
	    translate([wallLip, wallLip, -extraDepth]) {
		roundedCuboid(x-wallLip*2, y-wallLip*2, z+extraDepth-wallLip, radius-wallLip);
	    }
	    difference() {
		translate([-1, -1, -extraDepth-1]) {
		    roundedEdge(x+2, y+2, extraDepth+1, radius+1);
		}
		translate([wall+lipGap, wall+lipGap, -extraDepth-2]) {
		    roundedEdge(x-wall*2-lipGap*2, y-wall*2-lipGap*2, extraDepth+3, radius-wall-lipGap);
		}
	    }
	    translate([-1, -1, -extraDepth-1]) {
		cube([x+2, y+2, extraDepth-lipHeight+1]);
	    }
	}
    }
}

module roundedBox(boxDef) {
    baseRoundedBox(boxDef);
}

module roundedBoxLid(boxDef) {
    baseRoundedBoxLid(boxDef);
}

//$fn=30;

box = [
    ["x", 30],
    ["y", 40],
    ["z", 25],
    ["lidZ", 20],
    ["radius", 4],
    ["wall", 1],
    ["lipHeight", 2],
    ["lipWidth", 1],
    ["lipGap", 0.2],
    ];


roundedBox(box);

translate([0,0,10])
roundedBoxLid(box);
