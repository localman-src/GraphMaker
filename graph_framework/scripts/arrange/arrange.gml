
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