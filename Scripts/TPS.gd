extends Label

func _physics_process(delta):
	text = "TPS: " + str(stepify(1 / delta, 0.1))
