extends Component
## Something that plays animations purely by signals
class_name PlayAnimationComponent


@export var animation_player: AnimationPlayer
@export var animation_to_play: StringName = &""

@export_group("Configuration")

func _enter_tree() -> void:
	assert(animation_player, "animation_player is not set")
	assert(
		animation_player.has_animation(animation_to_play),
		"animation_player do not have %s" % animation_to_play
	)

func play_animation() -> void:
	if !enabled: return
	animation_player.play(animation_to_play)

func play_backwards() -> void:
	if !enabled: return
	animation_player.play_backwards(animation_to_play)
	
	
func pause() -> void:
	if !enabled: return
	animation_player.pause()

func stop() -> void:
	if !enabled: return
	animation_player.stop()
