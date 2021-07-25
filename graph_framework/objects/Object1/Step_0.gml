/// @description Insert description here
// You can write your code in this editor

if mouse_check_button_pressed(mb_left) {
	force_directed(myGraph, iterations, 5, 50);
	iterations++;
	
}

if keyboard_check_pressed(ord("R")) game_restart();