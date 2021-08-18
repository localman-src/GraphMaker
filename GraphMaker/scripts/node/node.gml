/**
 * @func			node()
 * @desc			Node constructor. Has a tag, data, display coordinates, and a list of edges.
 */
function node() constructor {
	//Node Attributes
	self.graph_id = 0; //Point to the graph the node belongs to.
	self.node_id = 0; // Unique ID of the node in the graph.
	self.edges = ds_list_create(); //DS List of edge values, format [ {real} id, {real} type]
	self.relationships = ds_map_create(); //Non-edge relationships between nodes
	
	self.tag = ""; //String that the node is tagged with
	self.data = []; //Any data carried by the node.
	
	
	//Display Attributes
	self.display_x = 0;
	self.display_y = 0;
	
	
	index = function() {
		var _node_list = self.graph_id.nodes; //GML Quirk, points _node_list at self.graph_id.nodes;
		var _node_count = ds_list_size(_node_list);
		
		//Loop through node list to find one with matching ID return -1 if can't find match
		for (var _i = 0; _i<_node_count; _i++) {
			if (_node_list[| _i].node_id == self.node_id) return _i;
		}
		return -1;

	}
	
	//Returns a list of all adjacent nodes.
	neighbors = function() {
		
		var _edge_count = ds_list_size(self.edges);
		var _neighbors = ds_list_create();
		
		for (var _i = 0; _i <_edge_count; _i++) {
			ds_list_add(_neighbors, (self.graph_id.getNode(self.edges[| _i][0])));
		}
		
		return _neighbors;
	}
	
	tagEquals = function(_tag) {
		var _has_tag = self.tag == _tag ? true : false ;
		return _has_tag;
	}
	
	neighborTagEquals = function(_tag) {
		var _neighbors = self.neighbors();
		var _neighbor_count = ds_list_size(_neighbors);
		var _neighbors_matching_tag = ds_list_create();
		
		for (var _i = 0; _i < _neighbor_count; _i++) {
			if (_neighbors[| _i].tagEquals(_tag)) ds_list_add(_neighbors_matching_tag, _neighbors[| _i]);
		}
		
		return _neighbors_matching_tag;
	}
	
	isAdjacentTo = function(_node) {
		var _neighbors = self.neighbors();
		var _neighbor_count = ds_list_size(_neighbors);
		var _is_neighbor = false;
		
		for (var _i = 0; _i <_neighbor_count; _i++) {
			_is_neighbor = (_node == _neighbors[| _i]) ? true : _is_neighbor;	
		}
		
		return _is_neighbor;
	}

}

