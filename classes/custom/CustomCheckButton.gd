extends CheckButton
class_name CustomCheckButton

@export var audio_streams: ControlNodeSounds

func _ready():
	if !audio_streams:
		return
	if !audio_streams.sounds:
		return
	for sound_data in audio_streams.sounds:
		var signal_name: StringName = sound_data.get_signal_name()
		Utility.connect_signal(signal_name, self, sound_data.on_signal_triggered)
	
	ready()

func ready():
	pass
