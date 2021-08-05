/** @func			find(_node_list, _tag_array)
 *  @desc			Returns all nodes matching the _tag parameter.
 *  @param {struct} nodes		A ds_list of node structs to search
 *  @param {string} tag			The tag to search for in the node list.
 */
function match_tag(_nodes, _tag) {
	var _node_count = ds_list_size(_nodes);
	var _node_matches = ds_list_create();
	
	for (var _i = 0; _i < _node_count; _i++) {
		if (_nodes[| _i].tag == _tag) ds_list_add(_node_matches, _nodes[| _i]);
	}
	
	return _node_matches;
}

/** @func			simple_find(_node_list, _tag_array)
 *  @desc			Returns all nodes in a pattern such that tag_array[0] is adjacent to tag_array[1] format: [ "A", "B" ].
 *  @param {struct} node_list	A ds_list of node structs to search
 *  @param {string} tag_array	The tag pattern to search for in the node list.
 */
function simple_find(_node_list, _tag_array) {
	var _node_count = ds_list_size(_node_list);
	var _node_matches = ds_list_create();

	for (var _i = 0; _i < _node_count; _i++) {
		if (_node_list[| _i].tagEquals(_tag_array[0]) && ds_list_size(_node_list[| _i].neighborTagEquals(_tag_array[1]))>0) {
			ds_list_add(_node_matches,_node_list[| _i]);
		}
	}
	
	return _node_matches;
}

/** @func			find(_node_list, _tag_array)
 *  @desc			Returns all nodes in an arbitrary size tag pattern such that tag_array[0] is adjacent to all tag_array[n], format: [ "A", "B", ... ].
 *  @param {struct} node_list	A ds_list of node structs to search
 *  @param {string} tag_array	The tag pattern to search for in the node list.
 */
function find(_node_list, _tag_array) {
	
	//Early Out
	if (ds_list_size(_node_list)<1) return ds_list_create(); //Return empty list if no results.
	
	//Recursive Call
	if array_length(_tag_array)>2 { //If more than 2 conditions remaining
		var _a = array_pop(_tag_array); //Get the last condition in the array.
		var _b = simple_find(_node_list, [ _tag_array[0], _a]); //return the nodes that meet the first and last conditions
		
		return find(_b, _tag_array); //Recursive call with the updated match list and conditions.
	}
	
	//Base Case
	if array_length(_tag_array)==2 {
		return simple_find(_node_list, _tag_array); //If only 2 conditions return the nodes that meet these conditions
	}
	
	//Extra Functionality
	if array_length(_tag_array)==1 { //If only supplied one condition return all nodes tagged with that condition.
		return match_tag(_node_list, _tag_array[0]);
	}
	
}

function BFT(_graph, _s, _g) {
	var _goal = !is_undefined(_g) ? myGraph.getNode(_g) : undefined;
	
	var _node_count = ds_list_size(_graph.nodes);
	var _visited = array_create(_node_count);
	
	for ( var _i = 0; _i < _node_count; _i++ ) {
		_visited[_i] = false;
	}
	
	var _nq = ds_queue_create();
	_visited[myGraph.getNode(_s).index()] = true;
	ds_queue_enqueue(_nq, myGraph.getNode(_s));
	
	while(!ds_queue_empty(_nq)) {
		var _node = ds_queue_dequeue(_nq);
		show_debug_message(_node.index());
		
		if ( !is_undefined(_goal) && ( _node == _goal ) ) return _node;
		var _neighbors = _node.neighbors();
		var _neighbor_count = ds_list_size(_neighbors);
		
		for ( _i = 0; _i < _neighbor_count; _i++ ) {
			if (!_visited[_neighbors[| _i].index()]) {
				_visited[_neighbors[| _i].index()] = true;
				ds_queue_enqueue(_nq, _neighbors[| _i]);
			}
			
		}
		
	}
	
}

function dijkstras(_graph, _s) {
	var _node_count = ds_list_size(_graph.nodes);
	var _dist = array_create(_node_count); //Distance Values
	var _prev = array_create(_node_count); //Previous Node Pointers
	
	var _source_index = _graph.getNode(_s).index();
	var _pq = ds_priority_create();
	
	_dist[_source_index] = 0;
	_prev[_source_index] = _graph.getNode(_s);
	
	for ( var _i = 0; _i < _node_count; _i++ ) { //Set initial values and enqueue nodes
		if (_i != _source_index) {
			_dist[_i] = 1 << 32;
			_prev[_i] = undefined;
		}
		
		ds_priority_add(_pq, _graph.nodes[| _i], _dist[_i]);
	}
	
	while !ds_priority_empty(_pq) { //As long as nodes remain to be processed
		var _min = ds_priority_delete_min(_pq); //Take the closest node
		var _neighbors = _min.neighbors(); //Identify its neighbors
		var _neighbor_count = ds_list_size(_neighbors);
		
		for ( _i = 0; _i < _neighbor_count; _i++ ) { //For Each Neighbor
			if (!is_undefined(ds_priority_find_priority(_pq, _neighbors[| _i]))) { //That has not already been processed
				var _alt = _dist[_min.index()] + 1; //Compute Distance from closest node
				
				if (_alt < _dist[_neighbors[| _i].index()]) { //If the distance is less than its current distance
					_dist[_neighbors[| _i].index()] = _alt; //Replace it
					_prev[_neighbors[| _i].index()] = _min; //Tag the closest node as the neighbors previous node.
				
					ds_priority_change_priority(_pq, _neighbors[| _i], _alt) //Change priority of the neighbor
				}
			}
			
		}
		
		ds_list_destroy(_neighbors); //Clean up for DS
	}
	
	ds_priority_destroy(_pq); //Clean up for DS
	return [ _dist, _prev ];
	
}