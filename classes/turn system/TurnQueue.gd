## @tutorial: https://www.youtube.com/watch?v=FV4JkwI4OF4&list=PLhqJJNjsQ7KHaAQcGij5SmOPpFjrDTHUq&index=3
extends Node2D
class_name TurnQueue

static var active_character: Character

static var current_round: int: set = set_current_round

## -1 = not set
static var current_turn: int = -1;

static var characters: Array[Character] = []

func initialize() -> void:
	assert(get_child_count() > 0, "Theres no children in TurnQueue")

	for child: Character in get_children():
		characters.append(child)
		child.turn_ended.connect(_on_characters_turn_ended.bind(child))
	print(characters)
	active_character = characters[0]
	current_round = 0
	current_turn = 0


func play_turn() -> void:
	await get_tree().physics_frame
	print("Playing turn")
	active_character.start_turn()
	SignalBus.turn_started.emit(active_character)


func _input(event):
	if event.is_action_pressed("ACTION_ACCEPT"):
		play_turn()


func _on_characters_turn_ended(character: Character) -> void:
	await get_tree().physics_frame
	print(character)
	# var new_index = (current_turn + 1) % characters.size()
	# active_character = character

	# current_turn = new_index
	# if new_index == 0:
	# 	current_round += 1
	var active_character_index: int = active_character.get_index() + 1 if is_instance_valid(character) else current_turn
	var new_index = (active_character_index) % get_child_count()

	current_turn = new_index
	active_character = get_child(new_index)
	if new_index == 0:
		current_round += 1
	SignalBus.turn_ended.emit(active_character)
		

static func set_current_round(val: int) -> void:
	current_round = val
	SignalBus.round_changed.emit(current_round)
