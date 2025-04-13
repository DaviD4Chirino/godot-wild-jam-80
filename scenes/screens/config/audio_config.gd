extends VBoxContainer

func _ready():
	for child in get_children():
		child.VolumeSlider.drag_ended.connect(save_audio_levels.unbind(1))

func save_audio_levels():
	var dict = {}

	for child in get_children():
		dict[child.bus] = db_to_linear(
			AudioServer.get_bus_volume_db(child.bus)
			)
		pass

	# for bus in AudioStreamData.AudioBuses.values():

	SaveSystem.set_var(SavePaths.audio_settings, dict)
	SaveSystem.save()

func _restore_config():

	for child in get_children():
		child.VolumeSlider.value = 0.8

	save_audio_levels()
	
	pass