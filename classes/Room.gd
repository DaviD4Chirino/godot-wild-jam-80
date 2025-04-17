@tool
extends Area2D
class_name Room

## Size of the sprite
@export var size: Vector2i = Vector2i(32, 32)

@export var local_position: Vector2i = Vector2i.ZERO
# @export_group("Tiles sprites", "sprite_")

# @export var sprite_top: Texture2D
# @export var sprite_bottom: Texture2D
# @export var sprite_right: Texture2D
# @export var sprite_left: Texture2D
# @export var sprite_top_right: Texture2D
# @export var sprite_top_bottom: Texture2D
# @export var sprite_top_left: Texture2D
# @export var sprite_right_bottom: Texture2D
# @export var sprite_right_left: Texture2D
# @export var sprite_bottom_left: Texture2D
# @export var sprite_left_: Texture2D
# @export var sprite_: Texture2D


var neighbors: Dictionary[Vector2i, Room] = {
	Vector2i.UP: null,
	Vector2i.DOWN: null,
	Vector2i.LEFT: null,
	Vector2i.RIGHT: null,
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
