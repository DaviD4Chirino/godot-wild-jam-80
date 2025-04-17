@tool
extends Node2D

@export var tile_map_layer: TileMapLayer

func _on_walker_generator_generation_finished() -> void:
	print("ended")

	await get_tree().physics_frame

	var rooms: Dictionary[Vector2i, Node] = SceneTileMapLayer.scene_coords

	for coordinates: Vector2i in rooms.keys():
		var room: Room = rooms[coordinates]
		room.id = coordinates

	for coordinates: Vector2i in rooms.keys():
		var room: Room = rooms[coordinates]
		# print(room.id)

		# var rooms_values: Array[Node] = rooms.values()

		# var up_neighbor = rooms_values.find_custom(func(_room): return _room.id == coordinates + Vector2i.UP)
		# var down_neighbor = rooms_values.find_custom(func(_room): return _room.id == coordinates + Vector2i.DOWN)
		# var left_neighbor = rooms_values.find_custom(func(_room): return _room.id == coordinates + Vector2i.LEFT)
		# var right_neighbor = rooms_values.find_custom(func(_room): return _room.id == coordinates + Vector2i.RIGHT)
		var up_neighbor = tile_map_layer.get_neighbor_cell(coordinates, TileSet.CELL_NEIGHBOR_TOP_SIDE)
		var down_neighbor = tile_map_layer.get_neighbor_cell(coordinates, TileSet.CELL_NEIGHBOR_BOTTOM_SIDE)
		var left_neighbor = tile_map_layer.get_neighbor_cell(coordinates, TileSet.CELL_NEIGHBOR_LEFT_SIDE)
		var right_neighbor = tile_map_layer.get_neighbor_cell(coordinates, TileSet.CELL_NEIGHBOR_RIGHT_SIDE)

		# print(up_neighbor)
		# print(down_neighbor)
		# print(left_neighbor)
		# print(right_neighbor)

		room.neighbors = {
			Vector2i.UP: rooms[up_neighbor] if rooms.has(up_neighbor) else null,
			Vector2i.DOWN: rooms[down_neighbor] if rooms.has(down_neighbor) else null,
			Vector2i.LEFT: rooms[left_neighbor] if rooms.has(left_neighbor) else null,
			Vector2i.RIGHT: rooms[right_neighbor] if rooms.has(right_neighbor) else null,
		}
		# room.neighbors = {
		# 	Vector2i.UP: rooms_values[up_neighbor] if up_neighbor > -1 else null,
		# 	Vector2i.DOWN: rooms_values[down_neighbor] if up_neighbor > -1 else null,
		# 	Vector2i.LEFT: rooms_values[left_neighbor] if up_neighbor > -1 else null,
		# 	Vector2i.RIGHT: rooms_values[right_neighbor] if up_neighbor > -1 else null,
		# }

		print(room.neighbors)
		print(room.neighbor_string())
		room.update_sprite_coordinates()
	# for room: Room in rooms:
	# 	var room_tile_coords: Vector2i = room.get_meta("tile_coords")
	# 	room.id = room_tile_coords
	# 	room.neighbors = {
	# 		Vector2i.UP: room_where_id(
	# 			rooms,

	# 		),
	# 		Vector2i.DOWN: room_where_id(
	# 			rooms,
	# 			tile_map_layer.get_neighbor_cell(
	# 				room_tile_coords,
	# 				TileSet.CELL_NEIGHBOR_BOTTOM_SIDE
	# 			)
	# 		),
	# 		Vector2i.LEFT: room_where_id(
	# 			rooms,
	# 			tile_map_layer.get_neighbor_cell(
	# 				room_tile_coords,
	# 				TileSet.CELL_NEIGHBOR_LEFT_SIDE
	# 			)
	# 		),
	# 		Vector2i.RIGHT: room_where_id(
	# 			rooms,
	# 			tile_map_layer.get_neighbor_cell(
	# 				room_tile_coords,
	# 				TileSet.CELL_NEIGHBOR_RIGHT_SIDE
	# 			)
	# 		)
	# 	}
	# 	room.update_sprite_coordinates()
	# 	print(room.region)


func room_where_id(rooms: Array[Node], id: Vector2i) -> Room:
	var room_index = rooms.find_custom(
		func(room): return room.id == id
	)
	if room_index == -1:
		return null
	
	return rooms[room_index]

func _on_walker_generator_generation_started() -> void:
	print("started")
	pass # Replace with function body.
