@tool
extends Slot

func _ready():
	if !data || !data.icon:
		printerr("SlotData is empty or data.icon is empty")
		return

	%Icon.texture = data.icon