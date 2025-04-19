## @tutorial: https://www.youtube.com/watch?v=FV4JkwI4OF4&list=PLhqJJNjsQ7KHaAQcGij5SmOPpFjrDTHUq&index=3
extends Node2D
class_name TurnQueue

static var active_character: Character

static var current_round: int: set = set_current_round

func initialize() -> void:
	assert(get_child_count() > 0, "Theres no children in TurnQueue")
	active_character = get_child(0)
	current_round = 0


func play_turn() -> void:
	active_character.start_turn()
	SignalBus.turn_started.emit(active_character)
	await active_character.turn_ended
	var new_index = (active_character.get_index() + 1) % get_child_count()
	active_character = get_child(new_index)
	
	if new_index == 0:
		current_round += 1
	SignalBus.turn_ended.emit(active_character)


func _input(event):
	if event.is_action_pressed("ACTION_ACCEPT"):
		play_turn()


static func set_current_round(val: int) -> void:
	current_round = val
	SignalBus.round_changed.emit(current_round)
