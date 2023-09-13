extends Area2D

func grapple():
	Player.instance.retract_grapple()
	return true
