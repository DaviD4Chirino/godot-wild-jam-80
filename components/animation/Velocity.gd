extends Component
class_name VelocityComponent
## Apply acceleration and deceleration to [member CharacterBody2D.velocity].

## The target velocity when decelerating.
const DECELERATION_TARGET_VELOCITY: Vector2 = Vector2.ZERO

## The maximum speed (pixels per second).
@export_range(0.0, 1000.0, 0.01, "or_greater", "hide_slider") var max_speed: float = 64.0

## The acceleration coefficient (0.0-1.0).  1.0 is instantaneous (full speed at
## [i]t=0[/i]).
@export_range(0.0, 1.0, 0.01) var acceleration_coefficient: float = 1.0

## The deceleration coefficient (0.0-1.0).  1.0 is instantaneous (full speed at
## [i]t=0[/i]).
@export_range(0.0, 1.0, 0.01) var deceleration_coefficient: float = 1.0

## The direction of the velocity.
var direction: Vector2 = Vector2.ZERO

func _enter_tree() -> void:
	assert(owner is CharacterBody2D, "owner must be a CharacterBody2D")

func _physics_process(_delta: float) -> void:
	if not enabled: return

	# Accelerate if we have somewhere to go.
	if direction: # bool(Vector2.ZERO) == false
		_accelerate()
	else:
		# Decelerate if we're still moving.
		if owner.velocity:
			_decelerate()

	owner.move_and_slide()

# Accelerate the [member owner].
func _accelerate() -> void:
	var acceleration_rate: float = max_speed * acceleration_coefficient
	var speed = direction.normalized() * max_speed
	owner.velocity = owner.velocity.move_toward(speed, acceleration_rate)

# Decelerate the [member owner].
func _decelerate() -> void:
	var deceleration_rate: float = max_speed * deceleration_coefficient
	owner.velocity = owner.velocity.move_toward(DECELERATION_TARGET_VELOCITY, deceleration_rate)