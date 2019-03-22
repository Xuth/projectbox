use <struct.scad>;
use <rounded_box_lib.scad>;


function addCoreBoxDefs(boxDef) =
    concat(boxDef, [
	       ["radius", 3],
	       ["wall", 2],
	       ["lipHeight", 2],
	       ["lipWidth", 2],
	       ["lipGap", 0.2],
	       ["epsilon", 0.01],
	       ["lidScrew_vOffset", 5], // vertical offset for lid screws
	       ["lidScrew_threadRadius", 2.5 / 2], // tappable screw radius
	       ["lidScrew_radius", 3 / 2], // screw radius
	       ["lidScrew_flangeRadius", 6],
	       ["boss_h", 5],
	       ["boss_ir", 2.5 / 2],
	       ["boss_or", 3.5]
	       ]);

module addBoss(box, boss) {
    echo(boss);
    x = v(boss, "x");
    y = v(boss, "y");
    z = v(box, "wall");
    eps = v(box, "epsilon");
    innerR = v(boss, "ir", v(box, "boss_ir"));
    outerR = v(boss, "or", v(box, "boss_or"));
    h = v(boss, "h", v(box, "boss_h"));
    
    translate([x,y,z-eps]) {
	difference() {
	    cylinder(h = h+eps, r = outerR);
	    translate([0,0,-eps]) {
		cylinder(h=h+eps*3, r = innerR);
	    }
	}
		
    }
}

function baseX(b) = (v(b, "sizeX")-v(b,"holeSpaceX"))/2 + v(b, "placeX");
function baseY(b) = (v(b, "sizeY")-v(b,"holeSpaceY"))/2 + v(b, "placeY");

function genBossList(board) = [
    for (x = [baseX(board), baseX(board) + v(board, "holeSpaceX")])
	for (y = [baseY(board), baseY(board) + v(board, "holeSpaceY")])
	    concat( [["x", x],
		     ["y", y],
		     ["h", v(board, "z")]], v(board, "extras", []))];

module aboutFaceWall(box, wall) {
    faceWall(box, wall) {
	mirror([0,0,1]) {
	    children();
	}
    }
}

module faceWall(box, wall) {
    x = v(box, "x");
    y = v(box, "y");
    
    if (wall == 0) {
	mirror([0,0,1]) {
	    rotate([-90, 0, 0]) {
		children();
	    }
	}
    }
    if (wall == 1) {
	rotate([0, 0, 90]) {
	    rotate([90, 0, 0]) {
		children();
	    }
	}
    }
    if (wall == 2) {
	translate([0,y,0]) {
	    rotate([90, 0, 0]) {
		children();
	    }
	}
    }
    if (wall == 3) {
	translate([x, 0, 0]) {
	    rotate([90, 0, 90]) {
		mirror([0,0,1]) {
		    children();
		}
	    }
	}
    }
}

module addOuterLidScrew(boxDef, lidScrew) {
    wall = v(lidScrew, "wall"); 
    x = v(lidScrew, "offset");
    vOffset = v(lidScrew, "vOffset", v(boxDef, "lidScrew_vOffset", "wtf"));
    echo(vOffset);
    y = v(box, "lidZ") - vOffset;
    screwR = v(lidScrew, "radius", v(boxDef, "lidScrew_radius"));
    eps = v(boxDef, "epsilon");
    h = v(boxDef, "wall");
    faceWall(boxDef, wall) {
	translate([x, y, -eps]) {
	    cylinder(r1=screwR + h, r2=screwR, h=h+eps*2);
	}
    }
}

module addLidScrewFlange(box, ls, depth) {
    vOffset = v(ls, "vOffset", v(box, "lidScrew_vOffset"));
    offset = v(ls, "offset");
    r = v(ls, "flangeRadius", v(box, "lidScrew_flangeRadius"));
    
    faceWall(box, v(ls, "wall")) {
	translate([offset, -vOffset, -1]) {
	    cylinder(r = r, h = depth+1);
	    translate([-r, 0, 0])
		cube([r*2, vOffset+1, depth+1]);
	}
    }
}

module addLidScrewHole(box, ls, depth) {
    vOffset = v(ls, "vOffset", v(box, "lidScrew_vOffset"));
    offset = v(ls, "offset");
    r = v(ls, "threadRadius", v(box, "lidScrew_threadRadius"));
    faceWall(box, v(ls, "wall")) {
	translate([offset, -vOffset, 0])
	    cylinder(r=r, h=depth);
    }
}


module projectBox(boxDef) {
    box = addCoreBoxDefs(boxDef);

    difference() {
	union() {
	    roundedBox(box);
	    for (boss = v(box, "bossList", [])) {
		addBoss(box, boss);
	    }
	    
	}
	for (lidScrew = v(box, "lidScrewList", [])) {
	    addOuterLidScrew(box, lidScrew);
	}
    }
}


function maxFlangeDepth(box) =
    max(concat([v(box, "lidScrew_vOffset") + v(box, "lidScrew_flangeRadius")],
	       [for (ls = v(box, "lidScrewList", []))
		       v(ls, "vOffset", v(box, "lidScrew_vOffset")) +
		       v(ls, "flangeRadius", v(box, "lidScrew_flangeRadius"))
		   ]));
		    
module screwFlanges(box, flangeInset) {
    mfd = maxFlangeDepth(box);
    lh = v(box, "lipHeight");
    difference() {
	translate([0, 0, -1 - mfd]) {
	    cube([v(box, "x"), v(box, "y"), mfd - lh + 1]);
	}
	for (ls = v(box, "lidScrewList", [])) {
	    echo(ls);
	    echo(flangeInset);
	    addLidScrewFlange(box, ls, flangeInset);
	}
    }
}


module projectBoxLid(boxDef) {
    box = addCoreBoxDefs(boxDef);
    lipHeightOverride = maxFlangeDepth(box);
    baseLidDef = concat([["lipHeight", lipHeightOverride]], box);

    flangeInset = v(box, "wall") + v(box, "lipGap") + v(box, "lipWidth") + v(box, "epsilon");
    
    difference() {
	union() {
	    roundedBoxLid(baseLidDef);
	}
	translate([0, 0, v(box, "lidZ")]) {
	    screwFlanges(box, flangeInset);
	    for (lidScrew = v(box, "lidScrewList", [])) {
		addLidScrewHole(box, lidScrew, flangeInset);
	    }
	}
    }
}

module showBoard(boxDef, board) {
    box = addCoreBoxDefs(boxDef);
    %translate([0, 0, v(box, "wall")]) {
	translate([v(board, "placeX"), v(board, "placeY"), v(board, "z")]) {
	    cube([v(board, "sizeX"), v(board, "sizeY"), v(board, "thick")]);
	}
    }
}
		     
boss1 = [
    ["x", 10],
    ["y", 15],
    ["h", 7],
    ["or", 5],
    ["ir", 1.5],
    ];

boss2 = concat([["x", 35]], boss1);

lidScrew1 = [
    ["wall", 0],
    ["offset", 35]
    ];

lidScrew2 = concat([["wall", 2]], lidScrew1);


box = [
    ["x", 50],
    ["y", 70],
    ["z", 25],
    ["lidZ", 20],
    ["bossList", [boss1, boss2]],
    ["lidScrewList", [lidScrew1, lidScrew2]]
    ];

projectBox(box);
translate([0,0,15])
projectBoxLid(box);
