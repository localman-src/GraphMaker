/// @description Insert description here
// You can write your code in this editor

show_debug_overlay(true);
randomize();

counter = 0;
myGraph = newGraph(25).setGraphDrawOrigin(room_width/2, room_height/2);

simpleCircle(myGraph, 100);

myGraph.tagNode(0, "C");
myGraph.tagNode(1, "1");
myGraph.tagNode(2, "2");
myGraph.tagNode(3, "3");
myGraph.tagNode(4, "4");
myGraph.tagNode(5, "A");
myGraph.tagNode(6, "B");
myGraph.tagNode(10, "B");
myGraph.tagNode(15, "C");
myGraph.tagNode(20, "D");

for (var _i = 0; _i<myGraph.order(); _i++) {
	if (_i+1) % 5 != 0 myGraph.newEdge(_i, _i+1, 0);
	myGraph.newEdge(_i, _i+5, 0);
}



	////Randomize Starting Position
	//for (var _i = 0; _i < myGraph.order(); _i++) {
	//	myGraph.nodes[| _i].display_x = round(random(room_width));
	//	myGraph.nodes[| _i].display_y = round(random(room_height));
	//}


find_pattern(myGraph, "B");

//rule_parser("0:A 1:B 2:C; ${0-1, 0-2} > 0:A 1:B 2:c; ${0-2-1}");


