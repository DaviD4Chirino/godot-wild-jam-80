extends Player

signal roll_start
signal roll_end

func _ready() -> void:
	super ()
	SignalBus.rolling_ended.connect(_on_rolling_ended)


func _on_rolling_ended(winning_tokens: Array[Token]) -> void:
	var grouped_tokens: Dictionary[String, Variant] = SlotMachine.group_tokens(winning_tokens)

	for token: Variant in grouped_tokens.values():
		var duplicated_token: Token = (token["token"] as Token).duplicate(true)
		# this is conditional
		# duplicated_token.debug_multiplier *= (token["count"] * global_multiplier)
		duplicated_token.ability.value *= (token["count"] * SlotMachine.global_multiplier)
		print(duplicated_token.get_display_string())
		
		if !Enemy.target_enemy: printerr("Enemy.target_enemy is null"); return

		duplicated_token.ability.trigger(self, Enemy.target_enemy)

	end_turn()

func _emit_roll_start():
	roll_start.emit()

func _emit_roll_end():
	roll_end.emit()
