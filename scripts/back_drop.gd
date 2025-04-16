extends ColorRect


signal clicked

var mouse_in: bool = false

func _input(event: InputEvent) -> void:
	if event.is_action_released("MB1") && mouse_in:
		clicked.emit()

func _on_mouse_entered() -> void:
	mouse_in = true
	pass # Replace with function body.

func _on_mouse_exited() -> void:
	mouse_in = false
	pass # Replace with function body.
