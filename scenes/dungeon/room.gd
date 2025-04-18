@tool
extends Area2D
@export var data: Room: set = set_data
@export var icons_per_type: Dictionary[Room.Types, Texture2D] = {}

@export_group("Nodes")
@export var sprite_node: Sprite2D
@export var line_node: Line2D

#region: setters and getter

func _ready() -> void:
	if !data: return

	if data.is_connected(&"changed", on_data_changed): return
	data.changed.connect(on_data_changed)

	if icons_per_type.has(data.type):
		sprite_node.texture = icons_per_type[data.type]

func set_data(val: Room) -> void:
	data = val
	if !data: return
	if !data.is_connected(&"changed", on_data_changed):
		data.changed.connect(on_data_changed)


#endregion

func on_data_changed() -> void:
	if icons_per_type.has(data.type):
		sprite_node.texture = icons_per_type[data.type]