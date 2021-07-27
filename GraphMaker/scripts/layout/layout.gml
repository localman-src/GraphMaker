
/**
* @func			simpleCircle(_graph, _radius)
* @desc			Sets the display_x and display_y values for all nodes in the graph. This function evenly spaces nodes around a circle.
* @param {struct} _graph	Graph struct to set points for.
* @param {real} _radius	Radius of the circle to place the nodes onto.
*/	
function simpleCircle(_graph, _radius) {
	var _node_count = ds_list_size(_graph.nodes);
		var _angle_offset = floor( 360 / _node_count );
		
		for (var _i = 0; _i<_node_count; _i++) {
			_graph.nodes[| _i].display_x = round(lengthdir_x( _radius, _angle_offset * _i ));
			_graph.nodes[| _i].display_y = round(lengthdir_y( _radius, _angle_offset * _i ));
		}
		
}

/**
* @func			setGridDisplay(_radius)
* @desc			Sets the display_x and display_y values for all nodes. This function places the nodes into a grid with a specified number of columns.
* @param {real} _columns	The number of columns in the grid.
*/	
function simpleGrid(_graph, _columns) {
	var _node_count = ds_list_size(_graph.nodes);
		
		for (var _i = 0; _i < _node_count; _i++) {
			_graph.nodes[| _i].display_x = (64 * (_i % _columns));
			_graph.nodes[| _i].display_y = (64 * (_i div _columns));
			
		}
	
}

/**
* @func					force_directed(_graph, _steps)
* @desc					Positions nodes in a graph using force-directed placement. Edges are treated as springs with attractive forces. Nodes repel each other.
* @param {struct} _graph		Graph struct to set points for.
* @param {real} _steps			Number of iterations to run.
* @param {real} _crep			Constant for repulsion force between nodes. Greater values = greater repulsion force.
* @param {real} _cspr			Spring constant for edge force between connected nodes. Greater values = greater attractive force.
* @param {real} _distance_scale		Divides pixel distance by this scale to get repulsion force distance. Greater values = greater repulsion force.
* @param {real} _preferred_edge_length	Distance in pixels at which the attractive force = 0;
* @param {real} _repulsion_limit	Maximum distance in pixels for which the repulsion force will be applied. Greater values = greater layout spread. Tuning this param too high can result in hard to read layouts.
*/	
function force_directed(_graph, _steps, _crep, _cspr, _distance_scale, _preferred_edge_length, _repulsion_limit) {
	
	//Good Default Values:
	// _crep = 3;
	// _cspr = 30;
	// _distance_scale = room_width;
	// _preferred_edge_length = 25;
	// _repulsion_limit = 200;

	var _node_count = ds_list_size(_graph.nodes);
	var _edge_count = ds_list_size(_graph.edges);
	

	repeat (_steps) {
		for (var _i = 0; _i < _node_count; _i++) {
			var _sumxfrep = 0;
			var _sumyfrep = 0;
	
			var _sumxfatt = 0;
			var _sumyfatt = 0;
		

			var _edge_count = ds_list_size(_graph.nodes[| _i].edges);
			show_debug_message(string(_edge_count) + " edges.")
		
			//Repulsive Force From Nodes
			for (var _j = 0; _j < _node_count; _j++) {
				
				if (_i!=_j) { //Dont calculate repulsive force on self.
					//Calculate direction and distance from every other node.
					var _ijdir = point_direction(_graph.nodes[| _j].display_x, _graph.nodes[| _j].display_y, _graph.nodes[| _i].display_x, _graph.nodes[| _i].display_y);
					var _ijdis = point_distance(_graph.nodes[| _i].display_x, _graph.nodes[| _i].display_y, _graph.nodes[| _j].display_x, _graph.nodes[| _j].display_y)/(_distance_scale);
					
					//Calculate x and y components of repulsive force.
					if (_ijdis*_distance_scale<_repulsion_limit) {
						var _frepx = _crep/(_ijdis^2) * lengthdir_x(1, _ijdir);
						var _frepy = _crep/(_ijdis^2) * lengthdir_y(1, _ijdir);
					} else {
						var _frepx = 0;
						var _frepy = 0;
					}
					
				} else {
					_frepx = 0;
					_frepy = 0;
				}
			
				show_debug_message(string(_i) + "," + string(_j) + " Repulsive Force: " +string(_frepx) + "," + string(_frepy))
				_sumxfrep += _frepx;
				_sumyfrep += _frepy;
			}
			
		
			//Attractive Force from Edges
			for (var _j = 0; _j < _edge_count; _j++) {
				var _node_index = _graph.getNodeIndex(_graph.nodes[| _i].edges[| _j][0]);
				//Calculate direction and distance fromconnected node.
				var _ijdir = point_direction(_graph.nodes[| _i].display_x, _graph.nodes[| _i].display_y, _graph.nodes[| _node_index].display_x, _graph.nodes[| _node_index].display_y);
				var _ijdis = point_distance(_graph.nodes[| _i].display_x, _graph.nodes[| _i].display_y, _graph.nodes[| _node_index].display_x, _graph.nodes[| _node_index].display_y);
				
				show_debug_message(string(_ijdir));
				
				//Calculate the x and y components of the spring force
				var _fattx = (_cspr * ln( _ijdis / _preferred_edge_length ) )  * lengthdir_x(1, _ijdir);
				var _fatty = (_cspr * ln( _ijdis / _preferred_edge_length ) )  * lengthdir_y(1, _ijdir);
				
				show_debug_message(string(_i) + "," + string(_j) + " Attractive Force: " +string(_fattx) + "," + string(_fatty))
				_sumxfatt += _fattx;
				_sumyfatt += _fatty;
			}
			
			
			_graph.nodes[| _i].display_x += .5*_sumxfrep
			_graph.nodes[| _i].display_y += .5*_sumyfrep;
			
			_graph.nodes[| _i].display_x += .5*_sumxfatt
			_graph.nodes[| _i].display_y += .5*_sumyfatt;
			
			//_graph.nodes[| _i].display_x = clamp(_graph.nodes[| _i].display_x, 16, room_width-16);
			//_graph.nodes[| _i].display_y = clamp(_graph.nodes[| _i].display_y, 16, room_height-16);

			
			}
		}
}