## This class is meant to be used with TurnQueue as it has
## Necessary signals and functions to work properly
extends Node2D
class_name Character

@export var hp: HealthComponent = HealthComponent.new()

signal turn_started
signal turn_ended
signal died
signal hurt

## Call super() at the end
func play_turn() -> void:
	turn_started.emit()

## Call super() at the end
func end_turn() -> void:
	turn_ended.emit()