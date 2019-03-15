use <project_box_lib.scad>
use <struct.scad>

board1 = [
    ["sizeX", 50.45],
    ["sizeY", 70.1],
    ["thick", 1.5],
    ["holeSpaceX", 44.1],
    ["holeSpaceY", 63.75],
    ["placeX", 5],
    ["placeY", 5],
    ["z", 5],
    ];


board2 = [
    ["sizeX", 31.65],
    ["sizeY", 34.65],
    ["thick", 1.5],
    ["holeSpaceX", 27.1],
    ["holeSpaceY", 29.7],
    ["z", 3],
    ["placeX", 60],
    ["placeY", 10],
    ];

lidScrews = [
    [["wall", 0],
     ["offset", 25]],
    [["wall", 0],
     ["offset", 75]],
    [["wall", 2],
     ["offset", 25]],
    [["wall", 2],
     ["offset", 75]]];

box = [
    ["x", 100],
    ["y", 80],
    ["z", 30],
    ["lidZ", 25],
    ["bossList", concat(genBossList(board1), genBossList(board2))],
    ["lidScrewList", lidScrews],
    ];

echo(genBossList(board1, box));


$fn = 30;
projectBox(box);
showBoard(box, board1);
showBoard(box, board2);
translate([0,0,15])
projectBoxLid(box);
