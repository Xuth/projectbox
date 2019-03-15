# projectbox
Yet another openscad project box library.

Lots of people have created project boxes in OpenSCAD.  Besides the fact that I think this one is relatively decent, I'm sharing this more because I think it is an excellent example of using a simple structured data format that makes parameterizing the box definition _so_ much easier.

OpenSCAD _really_ needs an equivalent of a python dict or a javascript object.  With a bit code sitting in struct.scad you can get close with lists of lists and you get something looking like:

```
box = [
    ["x", 100],
    ["y", 80],
    ["z", 30],
    ["lidZ", 25],
    ["bossList", [[["x", 10],
                   ["y", 5]],
		  [["x", 20],
		   ["y", 35]]]],
    ["lidScrewList", [[["wall", 0],
                       ["offset", 50]],
		      [["wall", 2],
		       ["offset", 50]]]],
    ];
```

For a project box where you're placing multiple supports and overriding default parameters, you can easily have many dozens of parameters that become unwieldy to work with.

For a quick start, 
```
use <project_box_lib.scad>;
```

define a structure that looks like the above and pass it to the following modules:

```
projectBox(box);

translate([0,0,10]) // since otherwise you won't see the edge of the box
    projectBoxLid(box);
```

alternately look at demo_box.scad to see how I used this to make a project box for an actual project with a 50x70 protoboard and a smaller stepper motor controller board.

# Now, how to use this library:
First define the project box.  As shown above, the definition is a list of two element lists, each with a key and a value.  

main box object structure:

required keys:
* x: external dimension of the box in the x direction
* y: external dimension of the box in the y direction
* z: external dimension of the box in the z direction (including the lid)
* lidZ: height at which the box is cut between the main box and the lid

optional parameters with defaults:
* radius: radius of the rounded edges on the box (default 3)
* wall: wall thickness of the box (default 2)
* lipHeight: the dimension in the z direction of an internal lip aronund the edge of the lid (default 2)
* lipWidth: the thickness of internal lip around the edge of the lid (default 2)
* lipGap: the gap between the internal lip on the lid and the wall of the box (default 0.2)
* bossList: a list of parameter sets to place raised screw mounts for circuit boards (see below for parameters) (default [], ie an empty list)
* lidScrewList: a list of parameter sets to place lid screws (see below for parameters) (default [], ie an empty list)
* several parameters that set defaults for the contents of bossList and lidScrewList defined in their respective areas

boss object structure:

bosses are small mounts on the floor of the box for mounting circuit boards.

required keys:
* x: offset to the center of the boss in the x direction (from the external edge of the box)
* y: offset to the center of the boss in the y direction

optional parameters with defaults and the default key that sets the defaults in the main box definition:
* h: height of the boss from the internal floor.  (default 5, default key "boss_h")
* ir: inner radius of the boss.  Default is appropriate for an m3 screw (default 1.25, default key "boss_ir")
* or: outer radius of the boss.  (default 3.5, default key "boss_or")

optionally if you're using a simple rectangular circuit board with a rectangular screw pattern centered in it you can define a board object and use the function genBossList() to generate a list of four bosses.  This is defined further below.

lidScrew object structure:

this project box design brings down flanges from the box lid lip and allows the lid to be screwed on from the side.  The defaults are designed for using 5mm, M3 countersunk flathead screws to hold the box lid on.  Parameters can be changed to support other sizes of screws.  (todo: add an option to support non-countersunk screws).

required keys:
* wall: which box wall, 0 is along the x axis, 1 is along the y axis, 2 is the wall opposite the x axis, 3 is the wall opposite the y axis
* offset: horizontal offset to the center of the screw hole (from the x/y axis)

optional parameters with defaults and the default key that sets the defaults in the main box definition:
* vOffset: vertical offset from the lid (default 5, default key: "lidScrew_vOffset")
* threadRadius: radius that the screw threads into on the lid (default: 1.25, default key: "lidScrew_threadRadius")
* radius: radius that the threads push through in the box (default: 1.5, default key: "lidScrew_radius")
* flangeRadius: radius of the semicircle flange that hangs down from the lid (default 6: default key: lidScrew_flangeRadius")


Committing now... will keep writing more later
