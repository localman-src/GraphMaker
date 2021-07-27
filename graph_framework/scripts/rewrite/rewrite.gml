/** @func			find_pattern(graph, pattern)
 *  @param {struct} graph		The string representing the pattern to find inside the graph.
 *  @param {string} pattern		The string representing the pattern to find inside the graph.
 */
function find_pattern(_graph, _pattern) {
	var _search_space = ds_list_create();
	var _node_count = ds_list_size(_graph.nodes);
	for (var _i = 0; _i < _node_count; _i++) {
		ds_list_add(_search_space, _graph.nodes[| _i].node_id);
	}
	
	
	
	//Pattern Parser Goes Here
	var _tag_array = [];
	_tag_array[0][0] = "A";
	_tag_array[0][1] = "B";
	_tag_array[0][2] = "C";
	
	ds_list_copy(_search_space, match_node_tag(_graph, _search_space, _tag_array[0][0]));
	
	var _a = match_edge_tag(_graph, _search_space, _tag_array[0][1]);
	var _b = match_edge_tag(_graph, _search_space, _tag_array[0][2]);

	if (ds_list_size(_a)>0) show_debug_message("Actual Match Found at [ " + string(_b[| 0][1]) + "," + string(_a[| 0][0]) + "," + string(_a[| 0][1]) + " ]");

}

function match_node_tag(_graph, _node_ids, _tag) {
	var _node_count = ds_list_size(_node_ids);
	var _node_matches = ds_list_create();
	
	for ( var _i = 0; _i < _node_count; _i++ ) {
			var _node_index = _graph.getNodeIndex(_node_ids[| _i]);
			if ( _graph.nodes[| _node_index].tag == _tag ) {
				ds_list_add(_node_matches, _graph.nodes[| _i].node_id);
				if (ds_list_size(_node_matches)>0) show_debug_message("Potential Match for " + string(_tag) + " Found At Node IDs: " + string(_node_matches[| ds_list_size(_node_matches)-1]));
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
				if (ds_list_size(_edge_matches)>0) show_debug_message("Potential Match for " + string(_tag) + " Found At Edge IDs: " + string(_edge_matches[| ds_list_size(_edge_matches)-1]));
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