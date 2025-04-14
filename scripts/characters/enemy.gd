extends Character
class_name Enemy

@export var abilities: Array[Ability]

func play_turn():
	super ()
	abilities.pick_random().trigger(self)
	await get_tree().physics_frame
	end_turn()