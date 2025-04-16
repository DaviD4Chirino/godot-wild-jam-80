extends Character
class_name Enemy

static var target_enemy: Enemy

@export var abilities: Array[Ability]
@export_group("Nodes", "node_")
@export var node_outline_color_rect: ColorRect
@export var node_progress_bar: ProgressBar

var mouse_in: bool = false
var shock_time: float = 0.0
var shock_active: bool = false

func _ready() -> void:
	SignalBus.enemy_selected.connect(_on_enemy_selected)
	node_progress_bar.max_value = hp.max_health
	node_progress_bar.value = hp.max_health
	hp.changed.connect(_on_health_component_hp_changed)

func play_turn():
	super ()
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
	if TurnQueue.active_character is not Player: return
	target_enemy = self
	SignalBus.enemy_selected.emit(target_enemy)

func set_mouse_in_true() -> void:
	mouse_in = true

func set_mouse_in_false() -> void:
	mouse_in = false

func _on_enemy_selected(enemy: Enemy) -> void:
	if enemy == self:
		node_outline_color_rect.show()
		return
	node_outline_color_rect.hide()

func _on_health_component_hp_changed(health: int) -> void:
	node_progress_bar.value = health
