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
 *  @param {struct} node_list	The search space of nodes for the given tag condition array.
 *  @param {string} tag_array	The tag pattern to search for in the node list.
 */
function find(_node_list, _tag_array) {
	
	if (ds_list_size(_node_list)<1) return -1; //If no results return -1.
	
	if array_length(_tag_array)>2 { //If more than 2 conditions remaining
		show_debug_message("tag array size: " + string(array_length(_tag_array)));
		show_debug_message("search space size: " + string(ds_list_size(_node_list)));
		
		var _a = array_pop(_tag_array); //Get the last condition in the array.
		var _b = simple_find(_node_list, [ _tag_array[0], _a]); //run the match list between the first and last conditions
		
		return find(_b, _tag_array); //Recursive call with the updated match list and conditions.
	}
	
	if array_length(_tag_array)==2 {
		show_debug_message("tag array size: " + string(array_length(_tag_array)));
		show_debug_message("search space size: " + string(ds_list_size(_node_list)));
		return simple_find(_node_list, _tag_array);
	}
}


/** @func			find_pattern(graph, pattern)
 *  @param {struct} graph		The string representing the pattern to find inside the graph.
 *  @param {string} pattern		The string representing the pattern to find inside the graph.
 */
function find_pattern(_graph, _pattern) {
	var _global_search_space = _graph.nodes;

	//Conditional Array formatted as:
	//_tag_array[Node Number 1][Node Tag, Neighbor Tag 1, Neighbor Tag 2 ... Neighbor Tag N]
	//_tag_array[Node Number 2][Node Tag, Neighbor Tag 1, Neighbor Tag 2 ... Neighbor Tag N]
	//_tag_array[    ...      ][                         ...                               ]
	//_tag_array[Node Number N][Node Tag, Neighbor Tag 1, Neighbor Tag 2 ... Neighbor Tag N]
	
	
	//Match Array Return formatted as:
	//_match_array[Node][Condition][Match]
	
	//_match_array[x=0][0] = ds_list containing pointers to every node matching the first condition.
	//_match_array[x>1][y][z] = ds_list point to nodes that match condition y that are adjacent to tag x for match number z.
	
	var _tag_array = [];
	_tag_array[0][0] = "A";
	_tag_array[0][1] = "B";
	_tag_array[0][2] = "C";

	
	var _condition_count = array_length(_tag_array);
	var _match_array = [];
	
	//For Node Pattern
	for (var _i = 0; _i < _condition_count; _i++) {
		var _condition_length = array_length(_tag_array[_i]); //How many Conditions the _ith node must match.
		
		_match_array[_i][0] = match_node_tag(_global_search_space, _tag_array[_i][0]); //All nodes matching the _ith node tag
		var _match_count = ds_list_size(_match_array[_i][0]); //How many matches for the _ith node tag.
		
		for (var _j = 1; _j < _condition_length; _j++) { //For each node pattern condition
			show_debug_message(string(_i) + "th " + "condition loop " + string(_j));
			
			for (var _k = 0; _k < _match_count; _k++) { //For each match
				show_debug_message("Match " + string(_k));
				_match_neighbors = match_node_tag(_match_array[_i][0][| _k].neighbors(), _tag_array[_i][_j]) //Get all neighbor nodes that match the tag condition
				
				_match_array[_i][_j][_k] = _match_neighbors; //Store match neighbors in the match array
				
				
			}	
		}	
	}
	
	//Match array now has all information about all nodes matching the pattern laid out in the tag array
	//TODO: Find some way to return this usefully.
	
	show_debug_message("#Nodes Matching " + string(_tag_array[0][0]) + ": " + string(ds_list_size(_match_array[0][0])));
	show_debug_message("#Nodes Matching " + string(_tag_array[0][1]) + " adjacent to " + string(_tag_array[0][0]) + ": " + string(ds_list_size(_match_array[0][1][0])));
	show_debug_message("#Nodes Matching " + string(_tag_array[0][2]) + " adjacent to " + string(_tag_array[0][0]) + ": " + string(ds_list_size(_match_array[0][2][0])));
	
	return _match_array;
}


function match_node_tag(_nodes, _tag) {
	var _node_count = ds_list_size(_nodes);
	var _node_matches = ds_list_create();
	
	for (var _i = 0; _i < _node_count; _i++) {
		if (_nodes[| _i].tag == _tag) ds_list_add(_node_matches, _nodes[| _i]);
	}
	return _node_matches;
}


