@tool
extends VBoxContainer
class_name AudioSlider
@export var bus: AudioStreamData.AudioBuses = AudioStreamData.AudioBuses.MASTER:
	set(value):
		bus = value
		if BusName:
			var text: String = AudioStreamData.AudioBuses.keys()[bus].capitalize()

			BusName.text = text + ":"
		pass

@export_group("Nodes")
@export var BusName: Label
@export var VolumeValue: Label
@export var VolumeSlider: HSlider

func _ready():
	update_default_values()

func update_value_text(value: float):
	VolumeValue.text = str(floori(value * 100)) + "%"

func update_default_values():
	if Engine.is_editor_hint(): return
	var audio_settings: Dictionary = SaveSystem.get_var(SavePaths.audio_settings, {})

	if audio_settings:
		var value = audio_settings[bus]
		VolumeSlider.value = value
		update_value_text(value)

func _on_volume_control_value_changed(value: float):
	update_value_text(value)

	match bus:
		AudioStreamData.AudioBuses.MASTER:
			SoundManager.set_master_volume(value)
			
		AudioStreamData.AudioBuses.MUSIC:
			SoundManager.set_music_volume(value)
			
		AudioStreamData.AudioBuses.UI:
			SoundManager.set_ui_sound_volume(value)
			
		AudioStreamData.AudioBuses.SFX:
			SoundManager.set_sound_volume(value)
