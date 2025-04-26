extends Level
class_name BattleEncounter

@export var enemies: Array[PackedScene] = []

@export_group("Nodes", "node_")
@export var node_roll_button: Button
@export var node_controls: Control
@export var node_turn_timer: Timer
@export var turn_queue: TurnQueue
	

func _ready() -> void:
	super ()
	assert(turn_queue, "You need a TurnQueue")
	spawn_enemies()
	node_roll_button.disabled = true
	node_controls.hide()
	
	turn_queue.initialize()

	if turn_queue.active_character is not Player:
		node_turn_timer.start()

	# SignalBus.enemy_selected.connect(_on_enemy_selected)
	connect_signals()

	# var e_pos = enemy_positions_node.get_children()
	
	await get_tree().create_timer(0.5).timeout
	turn_queue.play_turn()


func connect_signals():
	SignalBus.turn_started.connect(_on_turn_started)
	SignalBus.turn_ended.connect(_on_turn_ended)
	SignalBus.target_enemy_changed.connect(_on_enemy_selected)
		
func spawn_enemies() -> void:
	var screen_size: Vector2 = get_viewport_rect().size
	var half_screen: Vector2 = (screen_size * 0.5)

	for i: int in enemies.size():
		var new_enemy: Enemy = enemies[i].instantiate()
		var lerp_value = lerpf(
			screen_size.x * 0.15,
			screen_size.x * 0.85,
			(1.0 / (enemies.size() - 1)) * (i)
		)
		new_enemy.position.y = half_screen.y + 10 if i % 2 > 0 else half_screen.y - 10
		new_enemy.position.x = lerp_value
		
		new_enemy.target_enemy_changed.connect(_on_enemy_selected)
		new_enemy.died.connect(_on_enemy_dead)
		turn_queue.add_child(new_enemy)


func _on_enemy_selected(enemy: Enemy) -> void:
	node_roll_button.disabled = false if enemy else true

func _on_enemy_dead() -> void:
	print("Enemy died")


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
