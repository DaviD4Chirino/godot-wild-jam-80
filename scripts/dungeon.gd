@tool
extends Node2D

@export var tile_map_layer: TileMapLayer

func _on_walker_generator_generation_finished() -> void:
	print("ended")
	# for child in tile_map_layer.get_children():
	# 	if child is Node2D:
	# 		print(child.position == Vector2.ZERO)
	pass # Replace with function body.


func _on_walker_generator_generation_started() -> void:
	print("started")
	pass # Replace with function body.
