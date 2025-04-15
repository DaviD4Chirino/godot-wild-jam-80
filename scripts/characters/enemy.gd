extends Character
class_name Enemy

static var target_enemy: Enemy

@export var abilities: Array[Ability]
@export var node_progress_bar: ProgressBar

var mouse_in: bool = false
var shock_time: float = 0.0
var shock_active: bool = false

func _physics_process(delta: float) -> void:
	if shock_active:
		shock_time += delta
		$Material.set_shader_param("shock_time", shock_time)
	else:
		shock_time = 0.0
		$Material.set_shader_param("shock_time", shock_time)

func trigger_shock_effect():
	shock_active = true
	$Material.set_shader_param("trigger_shock", true)

func stop_shock_effect():
	shock_active = false
	$Material.set_shader_param("trigger_shock", false)

func _ready() -> void:
	node_progress_bar.max_value = hp.max_health
	node_progress_bar.value = hp.max_health
	hp.changed.connect(_on_health_component_hp_changed)

func play_turn():
	super ()
	abilities.pick_random().trigger(self, g.player)
	await get_tree().physics_frame
	end_turn()

func _input(event: InputEvent) -> void:
	if event.is_action_released("MB1"):
		if mouse_in:
			target_self()

func target_self() -> void:
	target_enemy = self
	SignalBus.enemy_selected.emit(target_enemy)

func set_mouse_in_true() -> void:
	mouse_in = true

func set_mouse_in_false() -> void:
	mouse_in = false

func _on_health_component_hp_changed(health: int) -> void:
	node_progress_bar.value = health
