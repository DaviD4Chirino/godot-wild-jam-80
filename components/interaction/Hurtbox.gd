extends Area2D
class_name Hurtbox

@export var health_component: HealthComponent

# the only difference between these and the health_component is the origin, honestly
signal damaged(amount: int)
signal healed(amount: int)

func _ready():
	assert(health_component, "You must provide a health_component")

func apply_damage(damage: int) -> void:
	health_component.damage(damage)
	damaged.emit(damage)

func apply_heal(amt: int) -> void:
	health_component.heal(amt)
	healed.emit(amt)
