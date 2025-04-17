@tool
extends Node2D

@export var tile_map_layer: TileMapLayer

func _on_walker_generator_generation_finished() -> void:
	print("ended")

	var rooms: Array[Node] = get_tree().get_nodes_in_group("dungeon_room") as Array[Node]
	
	for room: Room in rooms:
		var room_tile_coords: Vector2i = room.get_meta("tile_coords")
		room.id = room_tile_coords
		room.neighbors = {
			Vector2i.UP: room_where_id(
				rooms,
				tile_map_layer.get_neighbor_cell(
					room_tile_coords,
					TileSet.CELL_NEIGHBOR_TOP_SIDE
				)
			),
			Vector2i.DOWN: room_where_id(
				rooms,
				tile_map_layer.get_neighbor_cell(
					room_tile_coords,
					TileSet.CELL_NEIGHBOR_BOTTOM_SIDE
				)
			),
			Vector2i.LEFT: room_where_id(
				rooms,
				tile_map_layer.get_neighbor_cell(
					room_tile_coords,
					TileSet.CELL_NEIGHBOR_LEFT_SIDE
				)
			),
			Vector2i.RIGHT: room_where_id(
				rooms,
				tile_map_layer.get_neighbor_cell(
					room_tile_coords,
					TileSet.CELL_NEIGHBOR_RIGHT_SIDE
				)
			)
		}

		print(room.neighbors)

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
