extends Label

func _process(delta):
	text = "FPS: " + str(stepify(1 / delta, 0.1))
