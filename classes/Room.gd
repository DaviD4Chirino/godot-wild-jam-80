extends Area2D
# class_name Room
# @export var explored: bool:
# 	set(new_explored):
# 		explored = new_explored
# 		if explored:
# 			sprite.texture = explored_tile_set
# 		else:
# 			sprite.texture = unexplored_tile_set


# @export var region: Vector2i = Vector2i.ZERO: set = set_region

# @export var unexplored_tile_set: Texture2D
# @export var explored_tile_set: Texture2D

# @export var sprite: Sprite2D

# ## Size of the sprite
# var size: Vector2i = Vector2i(32, 32)
# var id: Vector2i = Vector2i(-999, -999)

# var neighbors: Dictionary[Vector2i, Room] = {
# 	Vector2i.UP: null,
# 	Vector2i.DOWN: null,
# 	Vector2i.LEFT: null,
# 	Vector2i.RIGHT: null,
# }: set = set_neighbors

# # clockwise [t r b l]
# var room_positions: Dictionary[String, Vector2i] = {
# 	"r": Vector2i(3, 0),
# 	"b": Vector2i(4, 0),
# 	"t": Vector2i(3, 1),
# 	"l": Vector2i(4, 1),

# 	"rb": Vector2i.ZERO,
# 	"bl": Vector2i(2, 0),
# 	"tl": Vector2i(2, 2),
# 	"tr": Vector2i(0, 2),

# 	"rbl": Vector2i(1, 0),
# 	"tbl": Vector2i(2, 1),
# 	"trl": Vector2i(1, 2),
# 	"trb": Vector2i(0, 1),
# 	"trbl": Vector2i(1, 1),

# 	"tb": Vector2i(4, 2),
# 	"rl": Vector2i(3, 2),
# }


# var is_full: bool:
# 	get:
# 		if (neighbors[Vector2i.UP] == null) && \
# 		(neighbors[Vector2i.DOWN] == null) && \
# 		(neighbors[Vector2i.LEFT] == null) && \
# 		(neighbors[Vector2i.RIGHT] == null):
# 			return true
# 		return false

# var neighbor_string: String:
# 	get:
# 		var string: String = ""

# 		if neighbors[Vector2i.UP] != null:
# 			string += "t"
# 		if neighbors[Vector2i.RIGHT] != null:
# 			string += "r"
# 		if neighbors[Vector2i.DOWN] != null:
# 			string += "b"
# 		if neighbors[Vector2i.LEFT] != null:
# 			string += "l"

# 		return string

# func update_sprite_coordinates() -> void:
# 	if neighbor_string == "": print("It has no neighbors")
# 	self.region = room_positions[neighbor_string]

# ## Returns an array with the keys of the empty neighbors
# func get_empty_neighbors() -> Array[Dictionary]:
# 	var neighbors_array: Array[Dictionary] = []

# 	for key: Vector2i in neighbors.keys():
# 		var room: Room = neighbors[key]
# 		if room == null:
# 			neighbors_array.append({key: null})
# 	# print(neighbors_array)
# 	return neighbors_array


# func set_region(val: Vector2i) -> void:
# 	region = val
# 	if sprite:
# 		sprite.region_rect = Rect2(region.x * 32, region.y * 32, 32, 32)

# func set_neighbors(val: Dictionary[Vector2i, Room]) -> void:
# 	neighbors = val
# 	# print(val)
# 	pass