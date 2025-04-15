## @tutorial: https://www.youtube.com/watch?v=FV4JkwI4OF4&list=PLhqJJNjsQ7KHaAQcGij5SmOPpFjrDTHUq&index=3
extends Node2D
class_name TurnQueue

var active_character: Character
static var combat_round: int = 0

func initialize() -> void:
	assert(get_child_count() > 0, "Theres no children in TurnQueue")
	active_character = get_child(0)
	combat_round = 0


func play_turn() -> void:
	active_character.start_turn()
	await active_character.turn_ended
	var new_index = (active_character.get_index() + 1) % get_child_count()
	active_character = get_child(new_index)
	
	if new_index == 0:
		combat_round += 1


func _input(event):
	if event.is_action_pressed("ACTION_ACCEPT"):
		play_turn()