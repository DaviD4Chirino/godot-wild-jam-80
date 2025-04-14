extends Control
class_name Level

@export var turn_queue: TurnQueue

static var is_paused: bool = false

func _ready():
	g.current_level = self
	assert(turn_queue, "You need a TurnQueue")
	turn_queue.initialize()

static func pause() -> void:
	is_paused = true
	Utility.pause_game()

static func resume() -> void:
	is_paused = false
	Utility.resume_game()

static func restart() -> void:
	is_paused = false
	Utility.restart_game()
