/**
 * @function			newGraph(_order)
 * @description			Creates a new graph with _order number of nodes.
 * @param {real} _order		The order of the graph to be created.
 */
function newGraph(_order) {
	var _graph = new graph();
	
	repeat (_order) _graph.newNode();
	
	return _graph;
}