/// @description Insert description here
// You can write your code in this editor

myGraph = newGraph(25);
myGraph.setGridDisplay(5);
//myGraph.setDisplayCoords(100);
myGraph.print();

myGraph.tagNode(1, "A");
myGraph.tagNode(3, "B");
myGraph.tagNode(5, "e");
myGraph.tagNode(7, "C");
myGraph.tagNode(9, "g");
myGraph.tagNode(0, "0");



//for (var _i = 0; _i<myGraph.order(); _i++) {
//	if ((_i+1)%5)!=0 myGraph.newEdge(_i, _i+1, 0)
//	myGraph.newEdge(_i, _i+5, 0);
//}


myGraph.updateAdjacency();
//for (var _i = 0; _i<10; _i++) {
//	show_debug_message(string(myGraph.nodes[| _i].edges[| 0]) + "\n");
	
//}

