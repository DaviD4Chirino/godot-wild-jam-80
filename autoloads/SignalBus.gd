extends Node
##Put all your signals here

func _ready():
	process_mode = PROCESS_MODE_ALWAYS

## Engine State Signals
signal game_paused
signal game_resumed
signal game_restarted
signal level_restarted
##

# Region without a description:
#region Slot Machine Signal
signal rolled_column(column_id: int, winner_token: Token)
signal rolling_ended(winning_tokens: Array[Token])

#endregion
##use this to check if the signal was emitted
func test_signal():
	print("test signal")
