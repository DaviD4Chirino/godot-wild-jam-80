extends Node2D
class_name SlotMachine

static var global_multiplier: float = 1.0: set = set_global_multiplier

func _ready():
	if Engine.is_editor_hint(): return
	g.slot_machine = self


# { "Attack":{"token":Token,"count":0} }
static func group_tokens(tokens: Array[Token]) -> Dictionary[String, Variant]:
	var dictionary: Dictionary[String, Variant] = {}

	for token in tokens:
		if dictionary.has(token.title):
			dictionary[token.title]["count"] += 1
			continue
		
		dictionary[token.title] = {
			"token": token,
			"count": 1
		}

	return dictionary

static func is_jackpot(_winning_tokens: Dictionary[String, Variant]) -> bool:
	if _winning_tokens.is_empty(): return false
	return _winning_tokens.values().size() == 1


static func set_global_multiplier(val: float) -> void:
	global_multiplier = val
	SignalBus.multiplier_changed.emit(global_multiplier)