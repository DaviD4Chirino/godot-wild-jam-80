@tool
extends Node
class_name DungeonGenerator

@export_tool_button("Generate") var generate_button = generate_map


@export var floors: int = 15
@export var rooms_per_floor: int = 5
@export var paths: int = 6
## distance between points
@export var distance: Vector2 = Vector2(25, 30)
@export var room_offset: float = 5.0
@export var room_type_weight: Dictionary[Room.Types, float] = {
	Room.Types.BATTLE: 0.6,
	Room.Types.SHOP: 0.3,
	Room.Types.CAMPFIRE: 0.1,
}

var random_room_type_weight: Dictionary[Room.Types, float] = {
	Room.Types.BATTLE: 0.0,
	Room.Types.SHOP: 0.0,
	Room.Types.CAMPFIRE: 0.0,
}
var random_room_type_total_weight: float = 0.0

## Array of Arrays of Room
static var map: Array[Array] = []


func generate_map() -> Array[Array]:
	map = generate_grid()
	var random_starting_points: Array[int] = get_random_starting_points()
	
	print("Random Starting Points:\t%s" % [random_starting_points])

	
	var i: int = 0
	for _floor in map:
		print("floor %s:\t%s" % [i, _floor])
		i += 1
		pass

	return map

func generate_grid() -> Array[Array]:
	var result: Array[Array] = []

	for i: int in floors:
		var adjacent_room: Array[Room] = []

		for j: int in rooms_per_floor:
			var new_room: Room = Room.new()
			var offset: Vector2 = Vector2(randf(), randf()) * room_offset

			new_room.position = Vector2(j * distance.x, i * distance.y) + offset

			new_room.row = i
			new_room.column = j
			new_room.next_rooms = []

			if i == floors - 1:
				new_room.position.y = (i + 1) * -distance.y
			
			adjacent_room.append(new_room)
		
		result.append(adjacent_room)

	return result

func get_random_starting_points() -> Array[int]:
	var y_coordinates: Array[int] = []
	var unique_points: int = 0

	while unique_points < 2:
		for i: int in paths:
			var starting_point: int = randi_range(0, rooms_per_floor - 1)

			if not y_coordinates.has(starting_point):
				unique_points += 1
				y_coordinates.append(starting_point)

	return y_coordinates

# @export var tile_map_layer: TileMapLayer

# func generate() -> void:
# 	await get_tree().physics_frame

# 	var rooms: Dictionary[Vector2i, Node] = SceneTileMapLayer.scene_coords

# 	for coordinates: Vector2i in rooms.keys():
# 		var room: Room = rooms[coordinates]
# 		room.id = coordinates

# 	for coordinates: Vector2i in rooms.keys():
# 		var room: Room = rooms[coordinates]


# 		var up_neighbor = tile_map_layer.get_neighbor_cell(coordinates, TileSet.CELL_NEIGHBOR_TOP_SIDE)
# 		var down_neighbor = tile_map_layer.get_neighbor_cell(coordinates, TileSet.CELL_NEIGHBOR_BOTTOM_SIDE)
# 		var left_neighbor = tile_map_layer.get_neighbor_cell(coordinates, TileSet.CELL_NEIGHBOR_LEFT_SIDE)
# 		var right_neighbor = tile_map_layer.get_neighbor_cell(coordinates, TileSet.CELL_NEIGHBOR_RIGHT_SIDE)
		
# 		# print("Room ID: %s" % room.id)
# 		# print("Up Neighbor: %s" % str(up_neighbor))
# 		# print("Down Neighbor: %s" % str(down_neighbor))
# 		# print("Left Neighbor: %s" % str(left_neighbor))
# 		# print("Right Neighbor: %s" % str(right_neighbor))
# 		# print(up_neighbor)
# 		# print(down_neighbor)
# 		# print(left_neighbor)
# 		# print(right_neighbor)

# 		room.neighbors = {
# 			Vector2i.UP: rooms[up_neighbor] if rooms.has(up_neighbor) else null,
# 			Vector2i.DOWN: rooms[down_neighbor] if rooms.has(down_neighbor) else null,
# 			Vector2i.LEFT: rooms[left_neighbor] if rooms.has(left_neighbor) else null,
# 			Vector2i.RIGHT: rooms[right_neighbor] if rooms.has(right_neighbor) else null,
# 		}
# 		# room.neighbors = {
# 		# 	Vector2i.UP: rooms_values[up_neighbor] if up_neighbor > -1 else null,
# 		# 	Vector2i.DOWN: rooms_values[down_neighbor] if up_neighbor > -1 else null,
# 		# 	Vector2i.LEFT: rooms_values[left_neighbor] if up_neighbor > -1 else null,
# 		# 	Vector2i.RIGHT: rooms_values[right_neighbor] if up_neighbor > -1 else null,
# 		# }

# 		# print(room.neighbors)
# 		# print(room.neighbor_string())
# 		room.update_sprite_coordinates()
	
# 	# for coordinates: Vector2i in rooms.keys():
# 	# 	var room: Room = rooms[coordinates]
# 	# 	print(room.id)
# 	# for room: Room in rooms:
# 	# 	var room_tile_coords: Vector2i = room.get_meta("tile_coords")
# 	# 	room.id = room_tile_coords
# 	# 	room.neighbors = {
# 	# 		Vector2i.UP: room_where_id(
# 	# 			rooms,

# 	# 		),
# 	# 		Vector2i.DOWN: room_where_id(
# 	# 			rooms,
# 	# 			tile_map_layer.get_neighbor_cell(
# 	# 				room_tile_coords,
# 	# 				TileSet.CELL_NEIGHBOR_BOTTOM_SIDE
# 	# 			)
# 	# 		),
# 	# 		Vector2i.LEFT: room_where_id(
# 	# 			rooms,
# 	# 			tile_map_layer.get_neighbor_cell(
# 	# 				room_tile_coords,
# 	# 				TileSet.CELL_NEIGHBOR_LEFT_SIDE
# 	# 			)
# 	# 		),
# 	# 		Vector2i.RIGHT: room_where_id(
# 	# 			rooms,
# 	# 			tile_map_layer.get_neighbor_cell(
# 	# 				room_tile_coords,
# 	# 				TileSet.CELL_NEIGHBOR_RIGHT_SIDE
# 	# 			)
# 	# 		)
# 	# 	}
# 	# 	room.update_sprite_coordinates()
# 	# 	print(room.region)

# func _input(event: InputEvent) -> void:
# 	if event.is_action_pressed("MB1"):
# 		generate()

# func room_where_id(rooms: Array[Node], id: Vector2i) -> Room:
# 	var room_index = rooms.find_custom(
# 		func(room): return room.id == id
# 	)
# 	if room_index == -1:
# 		return null
	
# 	return rooms[room_index]

# func _on_walker_generator_generation_started() -> void:
# 	print("started")
# 	pass # Replace with function body.


# func _on_walker_generator_grid_updated() -> void:
# 	print("updated")
# 	pass # Replace with function body.
