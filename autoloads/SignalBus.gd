extends Node
##Put all your signals here

func _ready():
	process_mode = PROCESS_MODE_ALWAYS

#region: Engine State Signals

signal game_paused
signal game_resumed
signal game_restarted
signal level_restarted
#endregion

#region: Slot Machine Signal
signal rolled_column(column_id: int, winner_token: Token)
signal rolling_ended(winning_tokens: Array[Token])
signal multiplier_changed(current_multiplier: float)
#endregion

#region: Enemy Signals
signal target_enemy_changed(enemy: Enemy)
#endregion

#region: TurnQueue Signals

signal turn_started(character: Character)
signal turn_ended(character: Character)

signal combat_ended()

## First emitted before the first Character plays his turn
signal round_changed(current_round: int)


#endregion

##use this to check if the signal was emitted
func test_signal():
	print("test signal")
