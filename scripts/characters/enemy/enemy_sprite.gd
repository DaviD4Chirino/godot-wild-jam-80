@tool
extends Sprite2D
@export var trigger_shock: bool = false: set = set_trigger_shock


var shock_time: float = 0.0

func _init() -> void:
	assert(self.material is ShaderMaterial, "You should have a Shader Material")

func _physics_process(delta: float) -> void:
	if trigger_shock:
		shock_time += delta
		(material as ShaderMaterial).set_shader_parameter("shock_time", shock_time)


func set_trigger_shock(val: bool) -> void:
	trigger_shock = val

	if !trigger_shock:
		shock_time = 0.0
		(material as ShaderMaterial).set_shader_parameter("shock_time", shock_time)
	(material as ShaderMaterial).set_shader_parameter("trigger_shock", trigger_shock)
