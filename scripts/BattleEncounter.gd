extends Level
class_name BattleEncounter

@export var enemies: Array[PackedScene] = []

@export_group("Nodes")
@export var roll_button: Button
@export var controls: Control
@export var turn_timer: Timer
@export var turn_queue: TurnQueue
@export var win_screen: Control

func _ready() -> void:
	super ()
	assert(turn_queue, "You need a TurnQueue")
	connect_signals()
	roll_button.disabled = true
	controls.hide()
	
	spawn_enemies()
	turn_queue.initialize()

	if turn_queue.active_character is not Player:
		turn_timer.start()

	
	await get_tree().create_timer(0.5).timeout
	turn_queue.play_turn()


func connect_signals():
	SignalBus.turn_started.connect(_on_turn_started)
	SignalBus.turn_ended.connect(_on_turn_ended)
	SignalBus.target_enemy_changed.connect(_on_enemy_selected)
	SignalBus.combat_ended.connect(_on_combat_ended)
		
func spawn_enemies() -> void:
	for enemy in enemies:
		var new_enemy: Enemy = enemy.instantiate()
		new_enemy.died.connect(_on_enemy_dead.bind(new_enemy))
		turn_queue.add_child(new_enemy)
	
	reposition_enemies()

func spawn_enemy(character: Character):
	character.died.connect(_on_enemy_dead.bind(character))
	turn_queue.add_child(character)
	reposition_enemies()

func reposition_enemies():
	var screen_size: Vector2 = get_viewport_rect().size
	var half_screen: Vector2 = (screen_size / 2)

	var group_enemies: Array[Node] = get_tree().get_nodes_in_group("enemy")
	print(group_enemies)

	if group_enemies.size() == 1:
		var new_enemy: Enemy = group_enemies[0]
		new_enemy.position = half_screen
		return

	for i: int in group_enemies.size():
		var new_enemy: Enemy = group_enemies[i]
		var lerp_value = lerpf(
			screen_size.x * 0.15,
			screen_size.x * 0.85,
			(1.0 / (group_enemies.size() - 1)) * (i)
		)
		new_enemy.position.y = half_screen.y + 10 if i % 2 > 0 else half_screen.y - 10
		new_enemy.position.x = lerp_value

func _on_enemy_selected(enemy: Enemy) -> void:
	roll_button.disabled = false if enemy else true

func _on_enemy_dead(enemy: Enemy) -> void:
	enemies.erase(enemy)


func _on_turn_started(character: Character) -> void:
	print("started")
	if character is Player:
		turn_timer.stop()
		controls.show()
	else:
		controls.hide()

func _on_combat_ended() -> void:
	turn_timer.stop()
	win_screen.show()

func _on_turn_ended(character: Character) -> void:
	if character is not Player:
		turn_timer.start()

func _on_turn_timer_timeout() -> void:
	turn_queue.play_turn()
