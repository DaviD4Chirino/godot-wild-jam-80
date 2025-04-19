@tool
extends Resource
class_name Room

enum Types {
	NONE,
	BATTLE,
	SHOP,
	CAMPFIRE,
	TREASURE,
	BOSS,
}

@export var type: Types = Types.NONE: set = set_type
@export var row: int = -1
@export var column: int = -1
@export var position: Vector2 = Vector2.ZERO
@export var next_rooms: Array[Room] = []

@export var selected: bool = false: set = set_selected

signal was_selected
signal was_unselected

func _init() -> void:
	changed.emit()

func _to_string() -> String:
	return "%s (%s)" % [column, Types.keys()[type]]

func set_selected(val: bool) -> void:
	selected = val

	if selected:
		was_selected.emit()
	else:
		was_unselected.emit()

func set_type(val: Types) -> void:
	type = val
	changed.emit()
