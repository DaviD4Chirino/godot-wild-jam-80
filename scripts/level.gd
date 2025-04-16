extends Level

@export_group("Nodes", "node_")
@export var node_roll_button: Button
@export var node_controls: Control
@export var node_turn_timer: Timer


func _ready() -> void:
	super ()
	SignalBus.enemy_selected.connect(_on_enemy_selected)
	node_roll_button.disabled = true

	SignalBus.turn_started.connect(_on_turn_started)
	SignalBus.turn_ended.connect(_on_turn_ended)
	node_controls.hide()

	if turn_queue.active_character is not Player:
		node_turn_timer.start()


func _on_enemy_selected(_enemy: Enemy) -> void:
	node_roll_button.disabled = false

func _on_turn_started(character: Character) -> void:
	if character is Player:
		node_turn_timer.stop()
		node_controls.show()
	else:
		node_controls.hide()

func _on_turn_ended(character: Character) -> void:
	if character is not Player:
		node_turn_timer.start()

func _on_turn_timer_timeout() -> void:
	turn_queue.play_turn()
