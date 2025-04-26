extends VBoxContainer

@export var audio_sliders: Array[AudioSlider] = []

func _ready():
	for audio_slider in audio_sliders:
		audio_slider.VolumeSlider.drag_ended.connect(save_audio_levels.unbind(1))

func save_audio_levels():
	var dict = {}

	for audio_slider in audio_sliders:
		dict[audio_slider.bus] = db_to_linear(
			AudioServer.get_bus_volume_db(audio_slider.bus)
			)
		pass

	# for bus in AudioStreamData.AudioBuses.values():

	SaveSystem.set_var(SavePaths.audio_settings, dict)
	SaveSystem.save()

func _restore_config():
	for audio_slider in audio_sliders:
		audio_slider.VolumeSlider.value = 0.8

	save_audio_levels()
	
	pass
