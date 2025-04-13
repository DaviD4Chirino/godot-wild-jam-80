@tool
extends Node2D

@export var tokens: Array[Token]

## The position of the column, base 0
@export var column_id: int = -1

var selected_token: Token


@export var spinning: bool = false: set = set_spinning

func get_size() -> Vector2:
	return %Sprite.texture.get_size()

func start_spinning() -> void:
	spinning = true

func finish_spinning() -> void:
	spinning = false

func spin() -> void:
	for slot_node: Slot in %Slots.get_children():
		slot_node.data = tokens.pick_random()


func set_spinning(val: bool) -> void:
	spinning = val
	if spinning:
		spin()
		%SpinTimer.start()
	if !spinning:
		%SpinTimer.stop()

func _on_spin_timer_timeout() -> void:
	spin()
