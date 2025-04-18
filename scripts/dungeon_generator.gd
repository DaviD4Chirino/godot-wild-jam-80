@tool
extends Node2D
class_name DungeonGenerator

@export_tool_button("Generate") var generate_button = generate_map

@export_range(5, 1000, 1) var floors: int = 15
@export var rooms_per_floor: int = 5
@export var paths: int = 6
## distance between points
@export var distance: Vector2 = Vector2(25, 30)
@export var room_offset: float = 5.0
@export var room_type_weight: Dictionary[Room.Types, float] = {
	Room.Types.BATTLE: 20,
	Room.Types.SHOP: 30,
	Room.Types.CAMPFIRE: 10,
}

var random_room_type_weights: Dictionary[Room.Types, float] = {
	Room.Types.BATTLE: 0.0,
	Room.Types.SHOP: 0.0,
	Room.Types.CAMPFIRE: 0.0,
}
var random_room_type_total_weight: float = 0.0

var first_floor: Array[Room]:
	get:
		return map[0] if !map.is_empty() else []

## Array of Arrays of Room
static var map: Array[Array] = []

signal generation_started
signal generation_ended

func generate_map() -> Array[Array]:
	generation_started.emit()
	map = generate_grid()
	var starting_points: Array[int] = get_random_starting_points()

	#region: modify the rooms
	for j: int in starting_points:
		var current_j: int = j
		for i: int in floors - 1:
			current_j = setup_connection(i, current_j)
	
	setup_boss_room()
	setup_random_room_weights()
	setup_room_types()
	
	#endregion

	#region: Dungeon debug prints
	
	var i: int = 0
	for _floor in map:
		print("floor %s:\t%s" % [i, _floor])
		i += 1

		var used_rooms = _floor.filter(
			func(room: Room): return room.next_rooms.size() > 0
		)

		print("used rooms:\t%s" % [used_rooms])

	print("Random Starting Points:\t%s" % [starting_points])
	#endregion
	
	generation_ended.emit()
	return map

func setup_boss_room() -> void:
	var middle: int = floori(rooms_per_floor * 0.5)
	var boss_room: Room = map[floors - 1][middle] as Room

	for j: int in rooms_per_floor:
		var current_room: Room = map[floors - 2][j] as Room

		if current_room.next_rooms:
			current_room.next_rooms.clear()
			current_room.next_rooms.append(boss_room)

	boss_room.type = Room.Types.BOSS

func setup_random_room_weights() -> void:
	random_room_type_weights[Room.Types.BATTLE] = room_type_weight[Room.Types.BATTLE]

	random_room_type_weights[Room.Types.CAMPFIRE] = \
		room_type_weight[Room.Types.CAMPFIRE] + room_type_weight[Room.Types.BATTLE]

	random_room_type_weights[Room.Types.SHOP] = \
		room_type_weight[Room.Types.CAMPFIRE] + \
		room_type_weight[Room.Types.BATTLE] + \
		room_type_weight[Room.Types.SHOP]
	
	random_room_type_total_weight = random_room_type_weights[Room.Types.SHOP]

func setup_room_types() -> void:
	# First floor is all battles
	for room: Room in map[0]:
		if room.next_rooms.size() > 0:
			room.type = Room.Types.BATTLE

	# Half floor
	for room: Room in map[int(floors * 0.5)]:
		if room.next_rooms.size() > 0:
			room.type = Room.Types.TREASURE

	# Floor before boss
	for room: Room in map[floors - 2]:
		if room.next_rooms.size() > 0:
			room.type = Room.Types.CAMPFIRE

	#Rest of rooms
	for _floor: Array[Room] in map:
		for room: Room in _floor:
			for next_room: Room in room.next_rooms:
				if next_room.type == Room.Types.NONE:
					_set_room_randomly(next_room)

func _set_room_randomly(room_to_set: Room) -> void:
	#region: Rules
	var campfire_below_4: bool = true
	var consecutive_campfire: bool = true
	var consecutive_shop: bool = true
	var campfire_on_13: bool = true
	#endregion

	var type_candidate: Room.Types

	while campfire_below_4 || consecutive_campfire || consecutive_shop || campfire_on_13:
		type_candidate = _get_random_room_type_by_weight()

		var is_campfire: bool = type_candidate == Room.Types.CAMPFIRE
		var has_campfire_parent: bool = _room_has_parent_of_type(room_to_set, Room.Types.CAMPFIRE)
		var is_shop: bool = type_candidate == Room.Types.SHOP
		var has_shop_parent: bool = _room_has_parent_of_type(room_to_set, Room.Types.SHOP)

		campfire_below_4 = is_campfire && room_to_set.row < 3
		consecutive_campfire = is_campfire && has_campfire_parent
		consecutive_shop = is_shop && has_shop_parent
		campfire_on_13 = is_campfire && room_to_set.row == floors - 2
	
	room_to_set.type = type_candidate

func _room_has_parent_of_type(room: Room, type: Room.Types) -> bool:
	var parents: Array[Room] = []

	#Left parent
	if room.column > 0 && room.row > 0:
		var parent_candidate: Room = map[room.row - 1][room.column - 1] as Room
		if parent_candidate.next_rooms.has(room):
			parents.append(parent_candidate)
	
	#Parent Below
	if room.row > 0:
		var parent_candidate: Room = map[room.row - 1][room.column] as Room
		if parent_candidate.next_rooms.has(room):
			parents.append(parent_candidate)
	
	#Right Parent
	if room.column < rooms_per_floor - 1 && room.row > 0:
		var parent_candidate: Room = map[room.row - 1][room.column + 1] as Room
		if parent_candidate.next_rooms.has(room):
			parents.append(parent_candidate)

	for parent: Room in parents:
		if parent.type == type:
			return true

	return false

func _get_random_room_type_by_weight() -> Room.Types:
	var roll: float = randf_range(0.0, random_room_type_total_weight)
	for type: Room.Types in random_room_type_weights:
		if random_room_type_weights[type] > roll:
			return type

	return Room.Types.BATTLE

#region: Generate the map functions

func generate_grid() -> Array[Array]:
	var result: Array[Array] = []

	for i: int in floors:
		var adjacent_room: Array[Room] = []

		for j: int in rooms_per_floor:
			var new_room: Room = Room.new()
			var offset: Vector2 = Vector2(randf(), randf()) * room_offset

			new_room.position = Vector2(j * distance.x, i * (-distance.y)) + offset

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

func setup_connection(i: int, j: int) -> int:
	var next_room: Room
	var current_room: Room = map[i][j] as Room

	@warning_ignore("unassigned_variable")
	while !next_room || _would_cross_existing_path(i, j, next_room):
		var random_j: int = clampi(randi_range(j - 1, j + 1), 0, rooms_per_floor - 1)

		next_room = map[i + 1][random_j]
	
	current_room.next_rooms.append(next_room)
	return next_room.column

func _would_cross_existing_path(i: int, j: int, room: Room) -> bool:
	var right_neighbor: Room
	var left_neighbor: Room

	if j > 0:
		left_neighbor = map[i][j]
	
	if j < rooms_per_floor - 1:
		right_neighbor = map[i][j + 1]

	if right_neighbor && room.column > j:
		for next_room: Room in right_neighbor.next_rooms:
			if next_room.column < room.column:
				return true
	if left_neighbor && room.column < j:
		for next_room: Room in left_neighbor.next_rooms:
			if next_room.column > room.column:
				return true
	return false
#endregion
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
