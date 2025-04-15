extends Ability
class_name DealDamageAbility

@export var cost: float

func trigger(_node: Node, target: Character) -> void:
	print("deal %s damage"%value)
	target.hp.damage(int(value))
