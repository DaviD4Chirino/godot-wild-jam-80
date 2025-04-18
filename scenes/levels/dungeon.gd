@tool
extends DungeonGenerator

@export_tool_button("Clear") var clear_button = clear_dungeon

@export_group("Scenes")
@export var room_scene: PackedScene

@export_group("Nodes")
@export var rooms_container: Node2D
@export var lines_container: Node2D
@export var camera_node: Camera2D


func _ready() -> void:
	generate_map()

func _on_generation_ended() -> void:
	generate_rooms()
	generate_lines()
	camera_node.position = first_floor[0].position

func generate_rooms() -> void:
	free_children(rooms_container)

	for _floor: Array[Room] in map:
		for room: Room in _floor:
			if room.type == Room.Types.NONE: continue

			var new_room_scene: RoomScene = room_scene.instantiate()
			new_room_scene.data = room
			new_room_scene.position = room.position
			rooms_container.call_deferred("add_child", new_room_scene)

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