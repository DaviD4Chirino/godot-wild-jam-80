extends Component
class_name GameStateComponent
@export var pause_menu: CanvasLayer

func _enter_tree() -> void:
	assert(pause_menu, "%s: This component needs a pause menu" % self.name)

func _ready():
	super()
	SignalBus.game_paused.connect(_on_game_paused)
	SignalBus.game_resumed.connect(_on_game_resumed)

	pause_menu.hide()

func _input(event: InputEvent):
	if event.is_action_pressed("ACTION_PAUSE"):
		if Level.is_paused:
			Level.resume()
			return

		Level.pause()
	
	pass

func _on_game_paused():
	# Cursor.mouse_mode = Input.MOUSE_MODE_VISIBLE
	pause_menu.show()

func _on_game_resumed():
	# Cursor.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pause_menu.hide()
