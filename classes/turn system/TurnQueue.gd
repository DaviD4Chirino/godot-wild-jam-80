## @tutorial: https://www.youtube.com/watch?v=FV4JkwI4OF4&list=PLhqJJNjsQ7KHaAQcGij5SmOPpFjrDTHUq&index=3
extends Node2D
class_name TurnQueue

var active_character: Character

func initialize() -> void:
	assert(get_child_count() > 0, "Theres no children in TurnQueue")
	active_character = get_child(0)


func play_turn() -> void:
	await active_character.turn_ended
	var new_index = (active_character.get_index() + 1) % get_child_count()
	active_character = get_child(new_index)