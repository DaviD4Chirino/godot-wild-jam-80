@tool
extends Slot

@export var empty_icon: Texture2D

func _ready():
	if !data || !data.icon:
		printerr("Token is empty or data.icon is empty")
		return

	%Icon.texture = data.icon


func set_data(val: Token) -> void:
	super (val)

	if !data || !data.icon:
		%Icon.texture = empty_icon
		return

	%Icon.texture = data.icon
