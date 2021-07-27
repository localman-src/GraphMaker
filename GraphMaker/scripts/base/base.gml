/**
 * @func			node()
 * @desc			Node constructor. Has a tag, display coordinates, and a list of edges.
 */
function node() constructor {
	self.node_id = 0;
	self.edges = ds_list_create();
	self.tag = "";
	self.data = [];
	
	self.display_x = 0;
	self.display_y = 0;

}

/**
 * @func			graph()
 * @desc			Graph constructor that houses all node and edge manipulation functions. Contains a list of nodes which contain a list of edges.
 */
function graph() constructor {
	self.nodes = ds_list_create();
	self.edges = ds_list_create();
	self.next_id = 0;
	self.adjacency = 0;
	
	self.display_origin_x = 0;
	self.display_origin_y = 0;
	
	/**
	 * @func			newNode()
	 * @desc			Creates a new node, gives it an ID, increments the ID counter.
	 */
	newNode = function() {
		var _i = new node();
		
		_i.node_id = self.next_id;
		self.next_id++;
		ds_list_add(self.nodes, _i);
		
		return self;
		
	}
	
	/**
	 * @func			getNodeIndex(_id)
	 * @desc			Takes a node ID and returns the index of it from the graphs self.nodes list.
	 * @param {real} _id		The ID of the node to get the index of.
	 */
	getNodeIndex = function(_id) {
		var _node_count = ds_list_size(self.nodes);
		//Loop through node list to find one with matching ID return -1 if can't find match
		for (var _i = 0; _i<_node_count; _i++) {
			if (self.nodes[| _i].node_id == _id) return _i;
		}
		return -1;
		
	}
	
	/**
	 * @func			tagNode(_id, _tag)
	 * @desc			Updates the tag parameter for the node with the given id.
	 * @param {real} _id		The ID of the node to update the tag on.
	 * @param {string} _tag		The tag to apply to the node.
	 */
	tagNode = function(_id, _tag) {
		var _id_index = getNodeIndex(_id);
		
			//update tag of the given node if it exists
			if (_id_index>=0) {
				self.nodes[| _id_index].tag = _tag;
			} else {
				show_debug_message("id exists: " + string(_id_index));
				return -1;
			}
		
	}
	
	/**
	 * @func			newEdge(_id1, _id2, _type)
	 * @desc			Takes two node IDs and creates an edge between them (0, undirected, 1, directed)
	 * @param {real} _id1		The ID of the first node.
	 * @param {real} _id2		The ID to connect to the first node.
	 * @param {real} _type		Type of connection (0, undirected, 1 directed from id1 to id2, -1 directed from id2 to id1).
	 */
	newEdge = function(_id1, _id2, _type) {
		var _id1_index = getNodeIndex(_id1);
		var _id2_index = getNodeIndex(_id2);
		
		//If both nodes exist add an edge to each of their edge lists
		//If one or both don't exist return -1
		if (_id1_index>=0 && _id2_index>=0) {
			ds_list_add(self.edges, [_id1, _id2]);
			ds_list_add(self.nodes[| _id1_index].edges, [_id2, _type])
			ds_list_add(self.nodes[| _id2_index].edges, [_id1, _type * -1])
			
		} else {
			show_debug_message("id1 exists: " + string(_id1_index) +"\nid2 exists: " + string(_id2_index))
			return -1;
		}
		
		return self;
	}
	
	/**
	 * @func			getEdgeIndex(_id1, _id2)
	 * @desc			Takes a node ID and returns the index of it from the graphs self.nodes list.
	 * @param {real} _id1		ID of the first node to check for edges from.
	 * @param {real} _id2		ID of the second node to check for edges from.
	 */
	getEdgeIndex = function(_id1, _id2) {
		var _e1 = [_id1, _id2];
		var _e2 = [_id2, _id1];
	
		//Loop through edge list to find one with matching pattern. Return -1 if can't find match
		for (var _i = 0; _i<ds_list_size(self.edges); _i++) {
			if (array_equals(self.edges[| _i], _e1) || array_equals(self.edges[| _i], _e2)) return _i;
		}
		return -1;
		
	}
	
	/**
	 * @func			removeEdge(_id1, _id2)
	 * @desc			Takes two node IDs and removes the edge between them if it exists. Also removes the edge from the node lists.
	 * @param {real} _id1		The ID of the first node.
	 * @param {real} _id2		The ID to connect to the first node.
	 * @param {real} _type		Type of connection (0, undirected, 1 directed from id1 to id2, -1 directed from id2 to id1).
	 */	
	removeEdge = function( _id1, _id2) {
		var _edge_index = self.getEdgeIndex(_id1, _id2);
		if ( _edge_index < 0 ) return -1; //early out if can't find edge;
		
		show_debug_message("Found Graph Edge " + string(_id1) + ","+ string(_id2));
		ds_list_delete(self.edges, _edge_index); //remove edge from graph struct.
		
		//Remove edge from both node structs.
		var _id1_index = getNodeIndex(_id1);
		var _id2_index = getNodeIndex(_id2);
		
		show_debug_message("Found Nodes " + string(_id1) + ","+ string(_id2));
		show_debug_message("Index " + string(_id1_index) + ","+ string(_id2_index))
		//If both nodes exist
		if (_id1_index>=0 && _id2_index>=0) {
			var _edge1_count = ds_list_size(self.nodes[| _id1_index].edges);
			var _edge2_count = ds_list_size(self.nodes[| _id2_index].edges);
			var _node_edge_index = -1;
			
			//loop through edges to find the matching edge
			for (var _i = 0; _i < _edge1_count; _i++) {
				if (self.nodes[| _id1_index].edges[| _i][0] == _id2) _node_edge_index = _i;
			}
			
			//delete the appropriate edge
			if (_node_edge_index > -1) ds_list_delete(self.nodes[| _id1_index].edges, _node_edge_index);
			
			//loop through edges to find the matching edge
			var _node_edge_index = -1;
			for (var _i = 0; _i < _edge2_count; _i++) {
				if (self.nodes[| _id2_index].edges[| _i][0] == _id1) _node_edge_index = _i;
			}
			//delete the appropriate edge
			if (_node_edge_index > -1) ds_list_delete(self.nodes[| _id2_index].edges, _node_edge_index);
			
			return self;
		} else return -2; // Return Error if nodes don't exist. This error state signifies that something has desynced the graph's edge list from the nodes'
					// Most likely something extremely broken happening if this result is returned.
		
	}
	
	/**
	 * @func			destroyNode(_id)
	 * @desc			Destroys the ID of the node if it exists and removes all edges from all connected nodes as well as the graph.
	 * @param {real} _id		The id of the node to be destroyed.
	 */
	destroyNode = function(_id) {
		var _node_index = getNodeIndex(_id);
		if (_node_index < 0) return -1; // Early out if requested node doesn't exist.
		
		var _edge_count = ds_list_size(self.nodes[| _node_index].edges);
		
		//Delink all nodes from the node to be destroyed.
		repeat(_edge_count) {
			show_debug_message(string(self.nodes[| _node_index].edges[| 0]));
			a = self.removeEdge( _id, self.nodes[| _node_index].edges[| 0][0])
			show_debug_message(string(a));
		}
		
		//Destroy ds_list in the node to prevent memory leak.
		ds_list_destroy(self.nodes[| _node_index].edges);
		//Delete the node from the graph struct.
		ds_list_delete(self.nodes, _node_index);
		
		return self;
	}
	
	/**
	 * @func			setGraphDrawOrigin(_x, _y)
	 * @desc			Sets the display origin point for the graph.
	 * @param {real} _x		The number of columns in the grid.
	 * @param {real} _y		The number of columns in the grid.
	 */	
	setGraphDrawOrigin = function(_x, _y) {
		self.display_origin_x = _x;
		self.display_origin_y = _y;
		
		return self;
	}
	
	/**
	 * @func			drawGraph(_origin_x, _origin_y)
	 * @desc			Draws all nodes and edges in the graph based on the origin offset and node display coordinates.
	 * @param {real} _origin_x	The origin point x position to offset the nodes from.
	 * @param {real} _origin_y	The origin point y position to offset the nodes from.
	 */
	draw = function() {
		var _node_count = ds_list_size(self.nodes);
		var _edge_count = ds_list_size(self.edges);
		
		//Draw Nodes
		for (var _i = 0; _i<_node_count; _i++) {
			draw_sprite(Sprite1, 0, self.nodes[| _i].display_x + self.display_origin_x, self.nodes[| _i].display_y + self.display_origin_y);
			draw_text(self.nodes[| _i].display_x + self.display_origin_x +15, self.nodes[| _i].display_y + self.display_origin_y-25, self.nodes[| _i].tag);
			
		}
		
		//Draw Edges
		for (var _j = 0; _j<_edge_count; _j++) {
			var _index1 = getNodeIndex(self.edges[| _j][0]);
			var _index2 = getNodeIndex(self.edges[| _j][1]);
			
			//show_debug_message(string(self.edges[| _j][0]) + "," + string(self.edges[| _j][1]));
			draw_line(self.nodes[| _index1].display_x + self.display_origin_x, self.nodes[|  _index1].display_y + self.display_origin_y, self.nodes[|  _index2].display_x + self.display_origin_x, self.nodes[|  _index2].display_y + self.display_origin_y);

		}
		
		//Draw Graph Properties
		draw_text(32,32, "Order: " + string(self.order()));
		draw_text(32,48, "Size : " + string(self.size()));
		
	}
	
	/**
	 * @func			order()
	 * @desc			Returns the current order of the graph (Order = Number of Nodes)
	 */
	order = function() {
	return ds_list_size(self.nodes);
		
	}
	
	/**
	 * @func			size()
	 * @desc			Returns the current size of the graph (Size = Number of Edges)
	 */
	size = function() {
	return ds_list_size(self.edges);	
		
	}
	
	/**
	 * @func			updateAdjacency()
	 * @desc			Updates the adjacency matrix for the graph based on all current edges. Could be faster if I knew how to only loop through above the diagonal.
	 */
	updateAdjacency = function() {
		for (var _i = 0; _i < ds_list_size(self.nodes); _i++) {
			for (var _j = 0; _j < ds_list_size(self.nodes); _j++) {
				var _e = getEdgeIndex(_i, _j);
				
				if ( _e >= 0 ) {
					self.adjacency[_i, _j] = 1;
					self.adjacency[_j, _i] = 1;
				} else self.adjacency[_i, _j] = 0;
			}
			
		}
		return self;
	}
	

	destroy = function() {
		var _node_count = ds_list_size(self.nodes);
		
		repeat (_node_count) {
			destroyNode(self.nodes[| 0]);
		}
		
		ds_list_destroy(self.nodes);
		ds_list_destroy(self.edges);
		
	}
	
}

