/// @description Insert description here
// You can write your code in this editor

if mouse_check_button_pressed(mb_left) {
	force_directed(myGraph, 25, 5, 50);
	
}

if keyboard_check_pressed(ord("R")) game_restart();