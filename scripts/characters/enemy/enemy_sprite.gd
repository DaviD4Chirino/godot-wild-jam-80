@tool
extends Sprite2D

enum Shaders {
	SHOCK_DAMAGE,
	FLASH,
}

@export var current_shader: Shaders = Shaders.FLASH: set = set_current_shader

@export var activate_shader: bool = false: set = set_activate_shader

var trigger_shock: bool = false
var trigger_flash: bool = false: set = set_trigger_flash

@export_group("shaders", "shader_")
@export var shader_flash: Shader
@export var shader_shock: Shader

var shock_time: float = 0.0

func _init() -> void:
	assert(self.material is ShaderMaterial, "You should have a Shader Material")

func _physics_process(delta: float) -> void:
	if trigger_shock:
		shock_time += delta
		(material as ShaderMaterial).set_shader_parameter("shock_time", shock_time)

func swap_shaders() -> void:
	match current_shader:
		Shaders.FLASH:
			(self.material as ShaderMaterial).shader = shader_flash

		Shaders.SHOCK_DAMAGE:
			(self.material as ShaderMaterial).shader = shader_shock
		_:
			(self.material as ShaderMaterial).shader = null

			
func set_current_shader(val: Shaders) -> void:
	current_shader = val
	activate_shader = false
	swap_shaders()

func set_activate_shader(val: bool) -> void:
	activate_shader = val
	match current_shader:
		Shaders.FLASH:
			use_flash()
		Shaders.SHOCK_DAMAGE:
			use_shock()
		

func use_flash() -> void:
	(material as ShaderMaterial).set_shader_parameter("active", activate_shader)

func use_shock() -> void:
	trigger_shock = activate_shader

	if !trigger_shock:
		shock_time = 0.0
		(material as ShaderMaterial).set_shader_parameter("shock_time", shock_time)

	(material as ShaderMaterial).set_shader_parameter("trigger_shock", trigger_shock)


func set_trigger_flash(val: bool) -> void:
	trigger_flash = val
	if trigger_flash:
		(material as ShaderMaterial).set_shader_parameter("active", true)

func set_trigger_shock(val: bool) -> void:
	trigger_shock = val

	if !trigger_shock:
		shock_time = 0.0
		(material as ShaderMaterial).set_shader_parameter("shock_time", shock_time)
	(material as ShaderMaterial).set_shader_parameter("trigger_shock", trigger_shock)
