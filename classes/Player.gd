extends Character
class_name Player
var is_dead: bool = false
func _ready() -> void:
	g.player = self
