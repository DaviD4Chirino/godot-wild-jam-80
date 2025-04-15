extends Level

@export_group("Nodes", "node_")
@export var node_roll_button: Button


func _ready() -> void:
	SignalBus.enemy_selected.connect(_on_enemy_selected)
	node_roll_button.disabled = true


func _on_enemy_selected(_enemy: Enemy) -> void:
	node_roll_button.disabled = false