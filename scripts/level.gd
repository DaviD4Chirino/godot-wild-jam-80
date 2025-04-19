extends Level

@export var enemies: Array[PackedScene] = []
@export var enemy_positions_node: Node2D
@export var enemy_positions: Hand

@export_group("Nodes", "node_")
@export var node_roll_button: Button
@export var node_controls: Control
@export var node_turn_timer: Timer


func _ready() -> void:
	super ()
	node_roll_button.disabled = true
	node_controls.hide()

	if turn_queue.active_character is not Player:
		node_turn_timer.start()

	SignalBus.enemy_selected.connect(_on_enemy_selected)
	SignalBus.turn_started.connect(_on_turn_started)
	SignalBus.turn_ended.connect(_on_turn_ended)

	var e_pos = enemy_positions_node.get_children()

	for i: int in enemies.size():
		var new_enemy = enemies[i].instantiate()
		new_enemy.position = e_pos[i].position
		turn_queue.add_child(new_enemy)

	await get_tree().create_timer(0.5).timeout
	turn_queue.play_turn()


func _on_enemy_selected(_enemy: Enemy) -> void:
	node_roll_button.disabled = false

func _on_turn_started(character: Character) -> void:
	print("started")
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


func _on_add_enemy_button_pressed() -> void:
	enemy_positions.add_node(enemies[0].instantiate())
	pass # Replace with function body.
