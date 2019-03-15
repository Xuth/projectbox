// tool to allow key/value "structs" in openscad

/* 

// create an object that looks like:

obj = [
    ["height", 20],
    ["width", 30],
    ["flange", 1],
    ["offset", 3.2]
    ];

// access with
w = v(obj, "width");
// (w is now 30)

// optionally add a default value:
inset = v(obj, "inset", def=4);
// (inset is now 4)


// in scad values are not mutable but we can "modify" or add to an object with the concat() function
newObj = concat([["inset", 8], ["height", 45]], obj);

newInset = v(newObj, "inset", def=4);
// (newInset is 8)

h = v(newObj, "height");
// h takes the first value of "height" and gets 45

*/

function v(obj, key, def=0) = 
    search([key], obj) == [[]] ? def : obj[search([key], obj)[0]][1];

