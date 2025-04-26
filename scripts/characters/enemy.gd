extends Character
class_name Enemy

static var active_enemies: Array[Enemy] = []

@export var abilities: Array[Ability]
@export_group("Nodes", "node_")
@export var node_outline_color_rect: ColorRect
@export var node_progress_bar: ProgressBar
@export var animation_player: AnimationPlayer

var target_enemy: Enemy: set = set_target_enemy

var mouse_in: bool = false
var shock_time: float = 0.0
var shock_active: bool = false
signal target_enemy_changed

func _ready() -> void:
	node_progress_bar.max_value = hp.max_health
	node_progress_bar.value = hp.max_health
	hp.changed.connect(_on_health_component_hp_changed)

	SignalBus.target_enemy_changed.connect(_on_enemy_selected)
	active_enemies.append(self)

func play_turn():
	if animation_player.is_playing():
		await animation_player.animation_finished
	super ()
	if dead:
		end_turn()
		return
	
	# So it takes a bit to finish animations and stuff
	await get_tree().create_timer(0.5).timeout
	abilities.pick_random().trigger(self, g.player)
	await get_tree().physics_frame
	end_turn()

func _input(event: InputEvent) -> void:
	if event.is_action_released("MB1"):
		if mouse_in:
			target_self()

func target_self() -> void:
	if dead: return
	for active_enemy in active_enemies:
		active_enemy.node_outline_color_rect.hide()

	if TurnQueue.active_character is not Player: return

	target_enemy = self
	target_enemy_changed.emit()
	SignalBus.target_enemy_changed.emit(self)

	node_outline_color_rect.show()


func set_mouse_in_true() -> void:
	mouse_in = true

func set_mouse_in_false() -> void:
	mouse_in = false

func set_target_enemy(val: Enemy) -> void:
	target_enemy = val
	SignalBus.target_enemy_changed.emit(val)

func _on_enemy_selected(enemy: Enemy) -> void:
	if enemy == self:
		node_outline_color_rect.show()
		return
	node_outline_color_rect.hide()

func _on_health_component_hp_changed(health: int) -> void:
	if dead: return
	node_progress_bar.value = health


func die() -> void:
	if dead: return
	dead = true
	died.emit()
	print("ENEMY DEAD")
	active_enemies.erase(self)
	target_enemy = null
	target_enemy_changed.emit()
	node_outline_color_rect.hide()
	end_turn()
	queue_free()
