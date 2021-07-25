/// @description Insert description here
// You can write your code in this editor
show_debug_overlay(true);
randomize();
myGraph = newGraph(25);
iterations = 1;
//simpleGrid(myGraph, 5);


//simpleGrid(myGraph, 4);
//myGraph.setDisplayCoords(100);

myGraph.tagNode(1, "A");
myGraph.tagNode(3, "B");
myGraph.tagNode(5, "e");
myGraph.tagNode(7, "C");
myGraph.tagNode(9, "g");
myGraph.tagNode(0, "0");



for (var _i = 0; _i<myGraph.order(); _i++) {
	if (_i+1) % 5 != 0 myGraph.newEdge(_i, _i+1, 0);
	myGraph.newEdge(_i, _i+5, 0);
}

	//Randomize Starting Position
	for (var _i = 0; _i < myGraph.order(); _i++) {
		myGraph.nodes[| _i].display_x = round(random(room_width));
		myGraph.nodes[| _i].display_y = round(random(room_height));
	}
	
//myGraph.newEdge(0, myGraph.order() -1,0);
//myGraph.removeEdge(0,1);
//myGraph.setGraphDrawOrigin(room_width / 3, room_height / 4);
myGraph.updateAdjacency();