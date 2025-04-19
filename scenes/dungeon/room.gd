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
signal data_was_selected
signal data_was_unselected
#endregion


func _ready() -> void:
	if !data: return
	update()


func update() -> void:
	connect_signals()

	if icons_per_type.has(data.type):
		sprite_node.texture = icons_per_type[data.type]
	

func connect_signals() -> void:
	if !data.is_connected(&"changed", _on_data_changed):
		data.changed.connect(_on_data_changed)

	if !data.is_connected(&"was_selected", _on_was_selected):
		data.was_selected.connect(_on_was_selected)

	if !data.is_connected(&"was_unselected", _on_was_unselected):
		data.was_unselected.connect(_on_was_unselected)

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

func _on_was_selected() -> void:
	data_was_selected.emit()

func _on_was_unselected() -> void:
	data_was_unselected.emit()

func _on_data_changed() -> void:
	if icons_per_type.has(data.type):
		sprite_node.texture = icons_per_type[data.type]

#endregion


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_released("MB1"):
		if !data.selected:
			data.selected = true
