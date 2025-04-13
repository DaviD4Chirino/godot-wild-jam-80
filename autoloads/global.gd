extends Node
##Autoload global script, access it as g

var playground: Node2D
var player: Player = null
var slot_machine: SlotMachine = null

func _ready():
	process_mode = PROCESS_MODE_ALWAYS
