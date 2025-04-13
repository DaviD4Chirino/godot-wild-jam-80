## Based on [url https://github.com/bluematt/godot4-components/blob/main/addons/bb-components/base_component.gd]
extends Node
class_name Component

#NOTE: use _enter_tree for the assertions

## This makes sure the component runs or not
@export var enabled: bool = true:
	set(val):
		enabled = val
		if enabled:
			was_enabled.emit()
		else:
			was_disabled.emit()

signal was_enabled
signal was_disabled

func _ready():
	owner.set_meta(self.name, self)

func _exit_tree() -> void:
	owner.remove_meta(self.name)

func enable() -> void:
	self.enabled = true

## Disable the component.	
func disable() -> void:
	self.enabled = false

## Return whether the component is enabled.
func is_enabled() -> bool:
	return enabled