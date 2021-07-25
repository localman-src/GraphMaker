/// @description Insert description here
// You can write your code in this editor
show_debug_overlay(true);

myGraph = newGraph(25);
simpleGrid(myGraph, 5);

//myGraph.simpleGrid(5);
//myGraph.setDisplayCoords(100);

myGraph.tagNode(1, "A");
myGraph.tagNode(3, "B");
myGraph.tagNode(5, "e");
myGraph.tagNode(7, "C");
myGraph.tagNode(9, "g");
myGraph.tagNode(0, "0");



for (var _i = 0; _i<myGraph.order(); _i++) {
	if ((_i+1)%5)!=0 myGraph.newEdge(_i, _i+1, 0)
	myGraph.newEdge(_i, _i+5, 0);
}

myGraph.print();
myGraph.removeEdge(0,1);

myGraph.destroyNode(20);
myGraph.setGraphDrawOrigin(room_width / 3, room_height / 4);
myGraph.updateAdjacency();