/** @func			find_pattern(graph, pattern)
 *  @param {struct} graph		The string representing the pattern to find inside the graph.
 *  @param {string} pattern		The string representing the pattern to find inside the graph.
 */
function find_pattern(_graph, _pattern) {
	var _global_search_space = _graph.nodes;
	var _local_search_space = ds_list_create();
	var _global_node_count = ds_list_size(_global_search_space);

	//Conditional Array formatted as:
	//_tag_array[Node Number 1][Node Tag, Neighbor Tag 1, Neighbor Tag 2 ... Neighbor Tag N]
	//_tag_array[Node Number 2][Node Tag, Neighbor Tag 1, Neighbor Tag 2 ... Neighbor Tag N]
	//_tag_array[    ...      ][                         ...                               ]
	//_tag_array[Node Number N][Node Tag, Neighbor Tag 1, Neighbor Tag 2 ... Neighbor Tag N]
	
	var _tag_array = [];
	_tag_array[0][0] = "A";
	_tag_array[0][1] = "B";
	_tag_array[0][2] = "C";
	
	var _condition_count = array_length(_tag_array);
	var _match_array = [];
	
	//For Every Condition
	for (var _i = 0; _i < _condition_count; _i++) {
		var _condition_length = array_length(_tag_array[_i]); //How many Conditions the _ith node must match.
		
		_match_array[_i][0] = match_node_tag(_global_search_space, "A"); //All nodes matching the _ith node tag
		
		var _match_count = ds_list_size(_match_array[_i][0]); //How many matches for the _ith node tag.
		var _match_neighbors = array_create(ds_list_size(_match_array[_i][0])); //Array to hold the neighbors for each match
		
		for (var _j = 1; _j < _condition_length; _j++) { //For each condition
			show_debug_message("condition loop " + string(_j));
			for (var _k = 0; _k < _match_count; _k++) { //For each match
				_match_neighbors[_k] = match_node_tag(_match_array[_i][0][| _k].neighbors(), _tag_array[0][_j]) //Get all neighbor nodes that match the tag condition
				
				_match_array[0][_j] = _match_neighbors[@ _k]; //Store match neighbors in the match array
			}
			
			
		
		}
	}
	
	show_debug_message("#Nodes Matching " + string(_tag_array[0][0]) + ": " + string(ds_list_size(_match_array[0][0])));
	show_debug_message("#Nodes Matching " + string(_tag_array[0][1]) + " adjacent to " + string(_tag_array[0][0]) + ": " + string(ds_list_size(_match_array[0][1])));
	show_debug_message("#Nodes Matching " + string(_tag_array[0][2]) + " adjacent to " + string(_tag_array[0][0]) + ": " + string(ds_list_size(_match_array[0][2])));
	
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


function rule_parser(_string) {
	// 0:A 1:B 2:C; ${0-1, 0-2} > 0:A 1:B 2:c; ${0-2-1}
	// Left half of this Should turn into:
	// var _tag_array = [];
	// _tag_array[0][0] = "A";
	// _tag_array[0][1] = "B";
	// _tag_array[0][2] = "C";
	
	//Split Find/Replace Strings
	var _rule_sep = string_pos(">", _string)
	show_debug_message(string(_rule_sep));
	
	var _find_rule = string_copy(_string,1,_rule_sep-1);
	show_debug_message(_find_rule);
	var _cn_start = string_pos("$", _find_rule);
	var _cn_end = string_pos("}", _find_rule);
	
	var _connections = string_copy(_find_rule, _cn_start, _cn_end - _cn_start + 1);
	show_debug_message(_connections);
}