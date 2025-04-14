extends Character


func play_turn():
	super ()
	print("Enemy %s dealt 10dmg" % name)
	await get_tree().physics_frame
	end_turn()