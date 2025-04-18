@tool
extends DungeonGenerator
@export var rooms_container: Node2D
@export var lines_container: Node2D
@export var room_scene: PackedScene

func _ready() -> void:
	generate_map()

func _on_generation_ended() -> void:
	generate_rooms()
	generate_lines()

func generate_rooms() -> void:
	for child in rooms_container.get_children():
		child.queue_free()

	for _floor: Array[Room] in map:
		for room: Room in _floor:
			if room.type == Room.Types.NONE: continue

			var new_room_scene: RoomScene = room_scene.instantiate()
			new_room_scene.data = room
			new_room_scene.position = room.position
			rooms_container.call_deferred("add_child", new_room_scene)

func generate_lines() -> void:
	for child in lines_container.get_children():
		child.queue_free()

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
