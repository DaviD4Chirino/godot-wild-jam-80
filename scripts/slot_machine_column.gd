@tool
extends Node2D

@export var center_slot: Slot

@export var tokens: Array[Token] = []

## The position of the column, base 0
@export var column_id: int = -1

## The token at the center of the the column
var selected_token: Token

@export var spinning: bool = false: set = set_spinning


func _ready() -> void:
	if tokens.size() > 0: spin()

func get_size() -> Vector2:
	return %Sprite.texture.get_size()

func start_spinning() -> void:
	spinning = true

func stop_spinning() -> void:
	spinning = false

func spin() -> void:
	for slot_node: Slot in %Slots.get_children():
		slot_node.token = tokens.pick_random()


func set_spinning(val: bool) -> void:
	spinning = val
	if spinning:
		spin()
		%SpinTimer.start()
	if !spinning:
		%SpinTimer.stop()
		selected_token = center_slot.token

func _on_spin_timer_timeout() -> void:
	spin()
