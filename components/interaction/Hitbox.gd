extends Area2D
## Designed to deal damage to any [hurtbox]
class_name HitBox
## If this is on, the damage will heal, duh
@export var heal: bool = false
@export_range(0, 1000, 1, "or_greater", "hide_slider") var damage_amount: int = 1

signal hit(hurtbox: Hurtbox, damage_amount: int, healing: bool)

func _ready():
	area_entered.connect(on_hurtbox_entered)

func on_hurtbox_entered(hurtbox: Area2D) -> void:
	if heal:
		hurtbox.apply_heal(damage_amount)
	else:
		hurtbox.apply_damage(damage_amount)

	hit.emit(hurtbox, damage_amount, heal)
