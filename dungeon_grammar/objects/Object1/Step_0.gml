/// @description Insert description here
// You can write your code in this editor

if (keyboard_check_pressed(vk_space)) {
	myGraph.newNode();
	myGraph.setDisplayCoords(100);
}

if mouse_check_button_pressed(mb_left) myGraph.newNodeAtClick();