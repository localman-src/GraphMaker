/// @description Insert description here
// You can write your code in this editor
counter ++
if mouse_check_button(mb_left) && counter%3==0 {
	force_directed(myGraph, 1);
	
}

if keyboard_check_pressed(ord("R")) {
	myGraph.destroy();
	delete myGraph;
	game_restart();
}