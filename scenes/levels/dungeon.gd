@tool
extends DungeonGenerator
class_name DungeonMap

@export_tool_button("Clear") var clear_button = clear_dungeon

@export_group("Scenes")
@export var room_scene: PackedScene

@export_group("Nodes")
@export var rooms_container: Node2D
@export var lines_container: Node2D
@export var camera_node: Camera2D

var rooms_scenes: Array[Array] = []

func _ready() -> void:
	generate_map()

func _on_generation_ended() -> void:
	generate_rooms()
	generate_lines()

	camera_node.position.x = dimensions.x / 2

	for _room_scene: RoomScene in rooms_scenes[0]:
		_room_scene.enabled = true
		

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

func clear_dungeon() -> void:
	free_children(lines_container)
	free_children(rooms_container)

func free_children(node: Node = self) -> void:
	for child in node.get_children():
		child.queue_free()

#* for the path:
	# all tiles disabled by default
	# enable all tiles in floor 0
	# once the player choses a room in a floor, lock all the other rooms in the same floor
	# enable the next rooms