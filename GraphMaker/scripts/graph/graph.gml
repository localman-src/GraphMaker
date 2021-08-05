

/**
 * @func			graph()
 * @desc			Graph constructor that houses all node and edge manipulation functions. Contains a list of nodes which contain a list of edges.
 */
function graph() constructor {
	self.nodes = ds_list_create();
	self.edges = ds_list_create();
	self.next_id = 0;
	
	self.display_origin_x = 0;
	self.display_origin_y = 0;
	
	/**
	 * @func			newNode()
	 * @desc			Creates a new node, gives it an ID, increments the ID counter.
	 */
	newNode = function() {
		var _i = new node();
		_i.node_id = self.next_id; //Set Unique ID
		self.next_id++; //Increment ID for next node
		_i.graph_id = self; //Point node to graph object.
		
		ds_list_add(self.nodes, _i);
		
		return self;
		
	}
	
	/**
	 * @func			getNodeIndex(_id)
	 * @desc			Takes a node ID and returns the index of it from the graphs self.nodes list.
	 * @param {real} _id		The ID of the node to get the index of.
	 */
	getNode = function(_id) {
		
		var _node_count = ds_list_size(self.nodes);
		//Loop through node list to find one with matching ID return -1 if can't find match
		for (var _i = 0; _i<_node_count; _i++) {
			if (self.nodes[| _i].node_id == _id) return self.nodes[| _i];
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
			var _node = self.getNode(_id);
			
			//update tag of the given node if it exists
			if (is_struct(_node)) {
				_node.tag = _tag;
			} else {
				show_debug_message("Node Does Not Exist");
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
		var _node_1 = getNode(_id1);
		var _node_2 = getNode(_id2);
		
		//If both nodes exist add an edge to each of their edge lists
		//If one or both don't exist return -1
		if (is_struct(_node_1) && is_struct(_node_2)) {
			ds_list_add(self.edges, [_id1, _id2]);
			ds_list_add(_node_1.edges, [_id2, _type])
			ds_list_add(_node_2.edges, [_id1, _type * -1])
			
		} else {
			show_debug_message(string(_id1) + " exists: " + string(is_struct(_node_1)) +"\n" + string(_id2) + " exists: " + string(is_struct(_node_2)));
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
		var _node_1 = getNode(_id1);
		var _node_2 = getNode(_id2);
		
		show_debug_message("Found Nodes " + string(_id1) + ","+ string(_id2));
		show_debug_message("Index " + string(_node_1.index()) + ","+ string(_node_2.index()))
		//If both nodes exist
		if (is_struct(_node_1) && is_struct(_node_2)) {
			var _edge1_count = ds_list_size(_node_1.edges);
			var _edge2_count = ds_list_size(_node_2.edges);
			var _node_edge_index = -1;
			
			//loop through edges to find the matching edge
			for (var _i = 0; _i < _edge1_count; _i++) {
				if (_node_1.edges[| _i][0] == _id2) _node_edge_index = _i;
			}
			
			//delete the appropriate edge
			if (_node_edge_index > -1) ds_list_delete(_node_1.edges, _node_edge_index);
			
			//loop through edges to find the matching edge
			var _node_edge_index = -1;
			for (var _i = 0; _i < _edge2_count; _i++) {
				if (_node_2.edges[| _i][0] == _id1) _node_edge_index = _i;
			}
			//delete the appropriate edge
			if (_node_edge_index > -1) ds_list_delete(_node_2.edges, _node_edge_index);
			
			return self;
		} else {
			return -2; // Return Error if nodes don't exist. This error state signifies that something has desynced the graph's edge list from the nodes'
		}		// Most likely something extremely broken happening if this result is returned.
		
	}
	
	/**
	 * @func			destroyNode(_id)
	 * @desc			Destroys the ID of the node if it exists and removes all edges from all connected nodes as well as the graph.
	 * @param {real} _id		The id of the node to be destroyed.
	 */
	destroyNode = function(_id) {
		var _node = getNode(_id);
		if (!is_struct(_node)) return -1; // Early out if requested node doesn't exist.
		
		var _edge_count = ds_list_size(_node.edges);
		
		//Delink all nodes from the node to be destroyed.
		repeat(_edge_count) {
			show_debug_message(string(_node.edges[| 0]));
			a = self.removeEdge( _id, _node.edges[| 0][0])
			show_debug_message(string(a));
		}
		
		//Destroy ds_list in the node to prevent memory leak.
		ds_list_destroy(_node.edges);
		//Delete the node from the graph struct.
		ds_list_delete(self.nodes, _node.index());
		
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
			var _node_1 = getNode(self.edges[| _j][0]);
			var _node_2 = getNode(self.edges[| _j][1]);
			
			//show_debug_message(string(self.edges[| _j][0]) + "," + string(self.edges[| _j][1]));
			draw_line(_node_1.display_x + self.display_origin_x, _node_1.display_y + self.display_origin_y,  _node_2.display_x + self.display_origin_x, _node_2.display_y + self.display_origin_y);

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

	destroy = function() {
		var _node_count = ds_list_size(self.nodes);
		
		repeat (_node_count) {
			destroyNode(self.nodes[| 0]);
		}
		
		ds_list_destroy(self.nodes);
		ds_list_destroy(self.edges);
		
	}
	
}

