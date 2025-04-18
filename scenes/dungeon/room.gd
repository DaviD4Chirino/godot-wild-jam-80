@tool
extends Area2D
class_name RoomScene
@export var data: Room: set = set_data
@export var icons_per_type: Dictionary[Room.Types, Texture2D] = {}

@export_group("Nodes")
@export var sprite_node: Sprite2D
@export var lines_node: Node2D
## instead of remaking new lines, it will duplicate this
@export var lines_template_node: Line2D

func _ready() -> void:
	if !data: return
	update()


func update() -> void:
	if !data.is_connected(&"changed", _on_data_changed):
		data.changed.connect(_on_data_changed)
	if icons_per_type.has(data.type):
		sprite_node.texture = icons_per_type[data.type]

	#region: point the lines to the neighbors
	
	
	#endregion
	

#region: setters and getter

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
