@tool
extends Slot

@export var empty_icon: Texture2D

func _ready():
	if !token || !token.icon:
		printerr("Token is empty or token.icon is empty")
		return

	%Icon.texture = token.icon


func set_token(val: Token) -> void:
	super (val)

	if !token || !token.icon:
		%Icon.texture = empty_icon
		return

	%Icon.texture = token.icon
