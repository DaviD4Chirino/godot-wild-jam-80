@tool
extends Node2D
class_name Slot


@export var token: Token: set = set_token


func set_token(val: Token) -> void:
	token = val