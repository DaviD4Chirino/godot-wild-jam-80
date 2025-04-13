@tool
extends Node2D
class_name Slot


@export var data: Token: set = set_data


func set_data(val: Token) -> void:
	data = val