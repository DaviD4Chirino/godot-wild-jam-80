@tool
extends DungeonGenerator
class_name DungeonMap

@export_tool_button("Clear") var clear_button = clear_dungeon
@export var generate_on_ready: bool = false

@export_group("Scenes")
@export var room_scene: PackedScene

@export_group("Nodes")
@export var rooms_container: Node2D
@export var lines_container: Node2D
@export var camera_node: Camera2D

var rooms_scenes: Array[Array] = []

#region: signals

signal floor_climbed(_floor: int)
#endregion

func _ready() -> void:
	if generate_on_ready:
		generate_map()

func _on_generation_ended() -> void:
	generate_rooms()
	generate_lines()

	camera_node.position.x = dimensions.x / 2

	climb_floor(0)
		
		
func generate_rooms() -> void:
	free_children(rooms_container)
	rooms_scenes.clear()

	for _floor: Array[Room] in map:
		var room_scenes_in_floor: Array[RoomScene] = []

		for room: Room in _floor:
			if room.type == Room.Types.NONE: continue
			
			var new_room_scene: RoomScene = room_scene.instantiate()
			new_room_scene.data = room
			new_room_scene.position = room.position
			room_scenes_in_floor.append(new_room_scene)
			rooms_container.call_deferred("add_child", new_room_scene)
		
		rooms_scenes.append(room_scenes_in_floor)
	
func generate_lines() -> void:
	free_children(lines_container)

	for _floor: Array[Room] in map:
		for room: Room in _floor:
			if room.next_rooms.is_empty(): continue

			for next: Room in room.next_rooms:
				var line: Line2D = Line2D.new()
				line.width = 2.0
				line.add_point(room.position)
				line.add_point(next.position)
				line.z_index = -1
				
				lines_container.call_deferred("add_child", line)

func climb_floor(_floor: int, previous_selected_room: RoomScene = null) -> void:
	var clamped_floor: int = clampi(_floor, 0, floors - 1)
	var current_floor: Array[RoomScene] = rooms_scenes[clamped_floor]

	var connect_signal = func(_room_scene: RoomScene):
		if !_room_scene.is_connected(&"data_was_selected", _on_room_selected):
			_room_scene.data_was_selected.connect(_on_room_selected.bind(_room_scene))

	# Disable the previous floor
	for room: RoomScene in rooms_scenes[clampi(_floor - 1, 0, floors - 1)]:
		room.enabled = false
	
	# enable only the next rooms from the previous_selected_room
	if previous_selected_room:
		for _room_scene: RoomScene in current_floor:
			if previous_selected_room.data.next_rooms.has(_room_scene.data):
				_room_scene.enabled = true
				connect_signal.call(_room_scene)
	else:
		# And enable only the rooms in this floor
		for _room_scene: RoomScene in current_floor:
			_room_scene.enabled = true

			connect_signal.call(_room_scene)

	camera_node.position.y = current_floor[0].position.y
	
	floor_climbed.emit(clamped_floor)


func clear_dungeon() -> void:
	free_children(lines_container)
	free_children(rooms_container)

func free_children(node: Node = self) -> void:
	for child in node.get_children():
		child.queue_free()

#region: Signal connections

func _on_room_selected(room: RoomScene) -> void:
	climb_floor(room.data.row + 1, room)
	room.data_was_selected.disconnect(_on_room_selected)


#endregion


#* for the path:
	# all tiles disabled by default
	# enable all tiles in floor 0
	# once the player choses a room in a floor, lock all the other rooms in the same floor
	# enable the next rooms
