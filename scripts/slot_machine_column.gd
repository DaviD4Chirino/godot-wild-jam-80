@tool
extends Node2D


func get_size() -> Vector2:
	return %Sprite.texture.get_size()