/**
 * @func			node()
 * @desc			Node constructor. Has a tag, data, display coordinates, and a list of edges.
 */
function node() constructor {
	self.node_id = 0;
	self.edges = ds_list_create();
	self.tag = "";
	self.data = [];
	
	self.display_x = 0;
	self.display_y = 0;
	

}