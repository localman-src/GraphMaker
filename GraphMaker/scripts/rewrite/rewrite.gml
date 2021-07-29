/** @func			find_pattern(graph, pattern)
 *  @param {struct} graph		The string representing the pattern to find inside the graph.
 *  @param {string} pattern		The string representing the pattern to find inside the graph.
 */
function find_pattern(_graph, _pattern) {
	var _global_search_space = ds_list_create();
	var _narrow_search_space = ds_list_create();
	var _node_count = ds_list_size(_graph.nodes);
	for (var _i = 0; _i < _node_count; _i++) {
		ds_list_add(_global_search_space, _graph.nodes[| _i].node_id);
	}
	
	//Tag Array formatted as:
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
	
	for (var _i = 0; _i < _condition_count; _i++) {
		for (var _n = 0; _n < array_length(_tag_array[_i]); _n++) {
			ds_list_copy(_narrow_search_space, match_node_tag(_graph, _global_search_space, _tag_array[0][_n]));
			
			var _neighbors = ds_list_create()
			
			for (var _j = 0; _j < ds_list_size(_narrow_search_space); _j++) {
			//show_debug_message("Searching For Neighbors of " + string(_narrow_search_space[| _j]));
			_match_array[_i][_j][0] = _narrow_search_space[| _j];
			_match_array[_i][_j][1] = _graph.neighbors(_narrow_search_space[| _j]);
	
			}
			
			for (var _j = 0; _j<array_length(_match_array[_i]); _j++) {
		
				var _match_length = ds_list_size(_match_array[_i][_j][1]);
				show_debug_message("Found Neighbors of " + string(_match_array[_i][_j][0]) + " at:");
	
				for (var _k = 0; _k<_match_length; _k++) {
					show_debug_message(string(_match_array[_i][_j][1][| _k]));
				}
			}
		}
	}

}

function match_node_tag(_graph, _node_ids, _tag) {
	var _node_count = ds_list_size(_node_ids);
	var _node_matches = ds_list_create();
	
	for ( var _i = 0; _i < _node_count; _i++ ) {
			var _node_index = _graph.getNodeIndex(_node_ids[| _i]);
			if ( _graph.nodes[| _node_index].tag == _tag ) {
				ds_list_add(_node_matches, _graph.nodes[| _i].node_id);
				if (ds_list_size(_node_matches)>0) show_debug_message("Match for " + string(_tag) + " Found At Node ID: " + string(_node_matches[| ds_list_size(_node_matches)-1]));
			}
		}
	
	return _node_matches;
}

function match_edge_tag(_graph, _node_ids, _tag) {
	var _node_count = ds_list_size(_node_ids);
	var _edge_matches = ds_list_create();
	
	for ( var _i = 0; _i < _node_count; _i++ ) {
		var _node_index = _graph.getNodeIndex(_node_ids[| _i]);
		var _edge_count = ds_list_size(_graph.nodes[| _node_index].edges);
		
		for ( var _j = 0; _j < _edge_count; _j ++) {
			var _node_at_edge = _graph.nodes[| _node_index].edges[| _j][0];
			var _node_at_edge_index = _graph.getNodeIndex(_node_at_edge);
			
			if ( _graph.nodes[| _node_at_edge_index].tag == _tag ) {
				ds_list_add(_edge_matches, [ _graph.nodes[| _node_index].node_id, _graph.nodes[| _node_at_edge_index].node_id]);
				if (ds_list_size(_edge_matches)>0) show_debug_message("Match for " + string(_tag) + " Found At Edge IDs: " + string(_edge_matches[| ds_list_size(_edge_matches)-1]));
			}
		
		}
		if (ds_list_size(_edge_matches)<=0) show_debug_message("No Matches Found for: " + string(_tag) + " from " + string(_node_ids[| _i]));
	}
	return _edge_matches;
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