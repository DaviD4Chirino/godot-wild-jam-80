extends Player


signal roll_start
signal roll_end

func _emit_roll_start():
	roll_start.emit()

func _emit_roll_end():
	roll_end.emit()