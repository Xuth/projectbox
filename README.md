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