@tool
extends Node2D

@export var tokens: Array[Token]

## The position of the column, base 0
@export var column_id: int = -1

func get_size() -> Vector2:
	return %Sprite.texture.get_size()