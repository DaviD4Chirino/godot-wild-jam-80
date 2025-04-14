extends Character


func play_turn():
	super ()
	print("Enemy %s dealt 10dmg" % name)
	end_turn()