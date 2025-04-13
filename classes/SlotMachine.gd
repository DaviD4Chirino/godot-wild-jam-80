extends Node2D
class_name SlotMachine


func _ready():
	if Engine.is_editor_hint(): return
	g.slot_machine = self