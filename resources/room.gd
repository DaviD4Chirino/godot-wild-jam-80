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

@export var selected: bool = false

func _init() -> void:
	changed.emit()

func _to_string() -> String:
	return "%s (%s)" % [column, Types.keys()[type]]


func set_type(val: Types) -> void:
	type = val
	changed.emit()