@tool
extends Area2D
class_name RoomScene


@export var data: Room: set = set_data
@export var enabled: bool = false: set = set_enabled

@export var icons_per_type: Dictionary[Room.Types, Texture2D] = {}


@export_group("Nodes")
@export var sprite_node: Sprite2D
@export var lines_node: Node2D
@export var coll_shape: CollisionShape2D

#region: Signals

signal was_enabled
signal was_disabled
#endregion


func _ready() -> void:
	if !data: return
	update()


func update() -> void:
	if !data.is_connected(&"changed", _on_data_changed):
		data.changed.connect(_on_data_changed)
	if icons_per_type.has(data.type):
		sprite_node.texture = icons_per_type[data.type]
	

#region: setters and getter

func set_enabled(val: bool) -> void:
	enabled = val
	coll_shape.disabled = !enabled
	
	if enabled:
		was_enabled.emit()
	else:
		was_disabled.emit()
	

func set_data(val: Room) -> void:
	data = val
	if !data: return
	update()

#endregion


#region: signal connections

func _on_data_changed() -> void:
	if icons_per_type.has(data.type):
		sprite_node.texture = icons_per_type[data.type]

#endregion


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action("MB1"):
		print("Clicked")
	pass # Replace with function body.
