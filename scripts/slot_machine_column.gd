@tool
extends Node2D

@export var tokens: SlotData

func get_size() -> Vector2:
	return %Sprite.texture.get_size()