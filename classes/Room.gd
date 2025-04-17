@tool
extends Area2D
class_name Room
@export var explored: bool:
	set(new_explored):
		explored = new_explored
		if explored:
			sprite.texture = explored_tile_set
		else:
			sprite.texture = unexplored_tile_set


@export var region: Vector2i = Vector2i.ZERO: set = set_region

@export var unexplored_tile_set: Texture2D
@export var explored_tile_set: Texture2D

@export var sprite: Sprite2D

## Size of the sprite
var size: Vector2i = Vector2i(32, 32)
var local_position: Vector2i = Vector2i.ZERO

var neighbors: Dictionary[Vector2i, Room] = {
	Vector2i.UP: null,
	Vector2i.DOWN: null,
	Vector2i.LEFT: null,
	Vector2i.RIGHT: null,
}
# clockwise [t r b l]
var room_positions: Dictionary[String, Vector2i] = {
	"r": Vector2i(3, 0),
	"d": Vector2i(4, 0),
	"u": Vector2i(3, 1),
	"l": Vector2i(4, 1),

	"rb": Vector2i.ZERO,
	"bl": Vector2i(2, 0),
	"tl": Vector2i(2, 2),
	"tr": Vector2i(0, 2),

	"rbl": Vector2i(1, 0),
	"tbr": Vector2i(2, 1),
	"trl": Vector2i(1, 2),
	"trb": Vector2i(0, 1),
	"trbl": Vector2i(1, 1),
}

# -1 = unplaced
var id: int = -1

var is_full: bool:
	get:
		if (neighbors[Vector2i.UP] == null) && \
		(neighbors[Vector2i.DOWN] == null) && \
		(neighbors[Vector2i.LEFT] == null) && \
		(neighbors[Vector2i.RIGHT] == null):
			return true
		return false

## Returns an array with the keys of the empty neighbors
func get_empty_neighbors() -> Array[Dictionary]:
	var neighbors_array: Array[Dictionary] = []

	for key: Vector2i in neighbors.keys():
		var room: Room = neighbors[key]
		if room == null:
			neighbors_array.append({key: null})
	print(neighbors_array)
	return neighbors_array


func set_region(val: Vector2i) -> void:
	region = val

	sprite.region_rect = Rect2(region.x * 32, region.y * 32, 32, 32)
