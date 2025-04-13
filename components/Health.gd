extends Component
class_name HealthComponent
## Keep track of a health-like numerical statistic.
## from https://github.com/bluematt/godot4-components

## The maximum allowed health.
@export_range(0, 1000, 1, "or_greater", "hide_slider") var max_health: int = 3:
	set(value):
		var old_max_health = max_health
		max_health = value

		if health > max_health:
			self.health = max_health
		else:
			var difference = abs(max_health - old_max_health)
			self.health += difference
			
		max_health_changed.emit(max_health)
	
## The current health.
@onready var health: int = max_health

## when hit, how many seconds it will last until is capable of take damage again
@export_range(0.0, 1000.0, 0.01, "or_greater", "hide_slider") var cooldown: float = 0.0

## If you want to not take any damage turn this on
@export var invulnerable: bool = false:
	set(value):
		invulnerable = value
		if invulnerable:
			invulnerability_started.emit()
		else:
			invulnerability_ended.emit()

## Emitted when health changes.
signal changed(health: int)
signal max_health_changed(max_health: int)

## Emitted when healing takes place.  Passes in the actual amount of healing up
## to [member max_health].
signal healed(amount: int)

## Emitted when fully healed.
signal healed_fully()

## Emitted when damage takes place.  Passes in the actual amount of damage.
signal damaged(amount: float)

## Emitted when health reaches 0.
signal died()

## Emitted when health has been restored after death.
signal revived()

signal invulnerability_started
signal invulnerability_ended

## Apply an amount of healing.  If [i]will_revive[/i] is true, the health can be
## from a "dead" state.
func heal(amount: int, will_revive: bool=false) -> void:
	if is_dead() and not will_revive: return

	var old_heath: int = health

	health += amount

	healed.emit(health - old_heath)
	changed.emit(health)

	if is_maxed():
		healed_fully.emit()

## Apply a full amount of healing.
func heal_fully() -> void:
	heal(max_health)

## Apply an amount of damage.
func damage(amount: int) -> void:
	if invulnerable: return

	var old_heath: int = health

	health -= amount

	damaged.emit(old_heath - health)
	changed.emit(health)
		
	if is_dead():
		died.emit()
		# if is dead we don´t care for the rest of the code
		return
	
	if cooldown > 0.0:
		invulnerable = true
		await get_tree().create_timer(cooldown, false).timeout
		invulnerable = false

## Return whether the health should be considered "dead".
func is_dead() -> bool:
	return not is_alive()
	
## Return whether the health should be considered "alive".
func is_alive() -> bool:
	return health > 0
	
## Return whether the health is maxed out.
func is_maxed() -> bool:
	return health >= max_health

## Revive the health from "dead" state.
func revive(amount: int) -> void:
	if is_dead() and amount > 0:
		heal(amount, true)
		revived.emit()