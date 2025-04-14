## This class is meant to be used with TurnQueue as it has
## Necessary signals and functions to work properly
extends Node
class_name Character


signal turn_started
signal turn_ended


func play_turn() -> void:
	turn_started.emit()

func end_turn() -> void:
	turn_ended.emit()