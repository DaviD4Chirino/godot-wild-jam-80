extends Control
class_name Level


static var is_paused: bool = false

func _ready():
	g.current_level = self

static func pause() -> void:
	is_paused = true
	Utility.pause_game()

static func resume() -> void:
	is_paused = false
	Utility.resume_game()

static func restart() -> void:
	is_paused = false
	Utility.restart_game()
