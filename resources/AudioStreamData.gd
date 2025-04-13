@tool
## A resource that takes a signal and a stream and connects it to an audio bus
class_name AudioStreamData extends Resource
enum SignalTypes {
	#Buttons
	pressed,
	#CheckButtons
	toggled,
	#Sliders
	drag_started,
	drag_ended,
	value_changed,
	#ScrollBars
	scrolling,
	scroll_ended,
	scroll_started,
	#TabContainer
	active_tab_rearranged,
	pre_popup_pressed,
	tab_button_pressed,
	tab_changed,
	tab_clicked,
	tab_hovered,
	tab_selected,
	#General
	mouse_entered,
	mouse_exited,
	focus_entered,
	focus_exited,
}
enum AudioBuses {
	MASTER,
	MUSIC,
	SFX,
	UI,
}
@export var signal_to_connect: SignalTypes
@export var stream: AudioStream
@export var bus: AudioBuses = AudioBuses.UI

func on_signal_triggered():

	SoundManager.play_sound(stream, AudioServer.get_bus_name(bus))
	# match bus:
	# 	AudioBuses.MASTER, AudioBuses.SFX:
	# 		SoundManager.play_sound(
	# 		stream,
	# 		AudioServer.get_bus_name(bus)
	# 	)

	# 	AudioBuses.MUSIC:
	# 		SoundManager.play_music(stream)

	# 	AudioBuses.UI:
	# 		SoundManager.play_ui_sound(stream)

func get_signal_name() -> StringName:
	return SignalTypes.keys()[signal_to_connect]
