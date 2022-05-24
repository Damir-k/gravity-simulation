extends TextureRect

const grid = preload("res://textures/tile1.png")
const white_space = preload("res://textures/whitetile.png")

func update_texture(is_button_pressed):
	if is_button_pressed:
		texture = grid
	else:
		texture = white_space
