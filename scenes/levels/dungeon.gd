@tool
extends DungeonGenerator

@export var room_scene: PackedScene

func _on_generation_ended() -> void:
	for child in get_children():
		child.queue_free()

	for _floor: Array[Room] in map:
		for room: Room in _floor:
			if room.type == Room.Types.NONE: continue

			var new_room_scene: RoomScene = room_scene.instantiate()
			new_room_scene.data = room
			new_room_scene.position = room.position
			call_deferred("add_child", new_room_scene)
