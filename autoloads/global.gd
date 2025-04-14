extends Node
##Autoload global script, access it as g

var current_level: Control
var player: Player = null
var slot_machine: SlotMachine = null

func _ready():
	process_mode = PROCESS_MODE_ALWAYS
