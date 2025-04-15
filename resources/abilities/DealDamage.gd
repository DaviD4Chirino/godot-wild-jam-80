extends Ability
class_name DealDamageAbility

@export var damage_amount: float
@export var cost: float

func trigger(_node: Node, target: Character) -> void:
	print("deal %s damage"%damage_amount)
	target.hp.damage(int(damage_amount))
