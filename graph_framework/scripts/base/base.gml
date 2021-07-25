/**
 * @func			node()
 * @desc			Node constructor. Has a tag, display coordinates, and a list of edges.
 */
function node() constructor {
	self.node_id = 0;
	self.edges = ds_list_create();
	self.tag = "";
	
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
		
	}
	
	/**
	 * @func			newNodeAtClick()
	 * @desc			Creates a new node using self.newNode(), places it at the x and y coordinates of the mouse click
	 */
	newNodeAtClick = function() {
		self.newNode();
		
		var _index = getNodeIndex(self.next_id - 1);
		
		self.nodes[| _index].display_x = mouse_x - self.display_origin_x; //This is not a good way to do this.
		self.nodes[| _index].display_y = mouse_y - self.display_origin_y; //Need to figure out drawing screen vs room
		
	}
	
	/**
	 * @func			getNodeIndex(_id)
	 * @desc			Takes a node ID and returns the index of it from the graphs self.nodes list.
	 * @param {real} _id		The ID of the node to get the index of.
	 */
	getNodeIndex = function(_id) {
		//Loop through node list to find one with matching ID return -1 if can't find match
		for (var _i = 0; _i<ds_list_size(self.nodes); _i++) {
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
	 * @desc			Returns the current size of the graph (Size = Number of Nodes)
	 */
	size = function() {
	return ds_list_size(self.edges);	
		
	}
	
	/**
	 * @func			print()
	 * @desc			Prints the list of nodes to the debug output.
	 */
	print = function() {
		for (var _i=0; _i<ds_list_size(self.nodes); _i++) {
			show_debug_message(string(self.nodes[| _i].node_id) + " " + string(self.nodes[| _i].display_x)+ " " + string(self.nodes[| _i].display_y))
		}
		
	}

	/**
	 * @func			simpleCircle(_radius)
	 * @desc			Sets the display_x and display_y values for all nodes. This function evenly spaces nodes around a circle.
	 * @param {real} _radius	Radius of the circle to place the nodes onto.
	 */	
	simpleCircleMethod = function(_radius) {
		var _node_count = ds_list_size(self.nodes);
		var _angle_offset = floor( 360 / _node_count );
		
		for (var _i = 0; _i<_node_count; _i++) {
			self.nodes[| _i].display_x = round(lengthdir_x( _radius, _angle_offset * _i ));
			self.nodes[| _i].display_y = round(lengthdir_y( _radius, _angle_offset * _i ));
		}
		
		
	}
	
	/**
	 * @func			simpleGrid(_radius)
	 * @desc			Sets the display_x and display_y values for all nodes. This function places the nodes into a grid with a specified number of columns.
	 * @param {real} _columns	The number of columns in the grid.
	 */	
	simpleGridMethod = function(_columns) {
		var _node_count = ds_list_size(self.nodes);
		
		for (var _i = 0; _i < _node_count; _i++) {
			self.nodes[| _i].display_x = (64 * (_i % _columns));
			self.nodes[| _i].display_y = (64 * (_i div _columns));
			
		}
		
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
			
			draw_line(self.nodes[| _index1].display_x + self.display_origin_x, self.nodes[|  _index1].display_y + self.display_origin_y, self.nodes[|  _index2].display_x + self.display_origin_x, self.nodes[|  _index2].display_y + self.display_origin_y);

		}
		
		//Draw Graph Properties
		draw_text(32,32, "Order: " + string(self.order()));
		draw_text(32,48, "Size : " + string(self.size()));
		
	}
	
	
	/**
	 * @func			updateAdjacency()
	 * @desc			Updates the adjacency matrix for the graph based on all current edges. Currently does not work.
	 */
	updateAdjacency = function() {
		self.adjacency = 0;
		for (var _i = 0; _i < ds_list_size(self.nodes); _i++) {
			for (var _j = 0; _j < ds_list_size(self.nodes); _j++) {
				if (ds_list_find_index(self.edges, [_i, _j]))!=-1 self.adjacency[_i][_j] = 1;
				if (ds_list_find_index(self.edges, [_j, _i]))!=-1 self.adjacency[_i][_j] = 1;
				
			}
			
		}
		//show_debug_message(string(self.adjacency[1][2]));	
	}
	
	destroyNode = function(_node) {
		
		
	}
	
}

