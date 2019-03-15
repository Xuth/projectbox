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

For a project box where you're placing multiple supports and overriding default parameters, you can easily have dozens of parameters that become unwieldy to work with.

# Now, how to use this library:
First define the project box.  As shown above, the definition is a list of two element lists, each with a key and a value.  The following keys are required:

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
* bossList: a list of parameter sets to place raised screw mounts for circuit boards (see below for parameters)
* lidScrewList: a list of parameter sets to place lid screws (see below for parameters)
* several parameters that set defaults for the contents of bossList and lidScrewList defined in their respective areas
