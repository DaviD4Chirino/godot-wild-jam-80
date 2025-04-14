extends Resource
class_name Token

## Will be used as identification
@export var title: String = ""
@export var icon: Texture2D

@export var display_string: String = "The [x] will be replaced by the multiplier"


@export var debug_multiplier: float

# Then we define their special properties like what to do when the roll is over, etc

func set_display_string(val: String) -> void:
	display_string = val
	pass

func get_display_string() -> String:
	return display_string.replacen("[x]", str(debug_multiplier))