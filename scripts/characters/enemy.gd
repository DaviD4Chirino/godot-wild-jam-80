extends Character
class_name Enemy

static var target_enemy: Enemy

@export var abilities: Array[Ability]

var mouse_in: bool = false

func play_turn():
	super ()
	abilities.pick_random().trigger(self)
	await get_tree().physics_frame
	end_turn()

func _input(event: InputEvent) -> void:
	if event.is_action_released("MB1"):
		if mouse_in:
			target_self()

func target_self() -> void:
	target_enemy = self

func set_mouse_in_true() -> void:
	mouse_in = true

func set_mouse_in_false() -> void:
	mouse_in = false