extends Camera2D

onready var grid = get_node("../Grid")

var drag_pos = Vector2.ZERO
var max_zoom = Vector2(4, 4)
var min_zoom = Vector2(0.20001, 0.20001)
var following_centre = false
var in_gui = false

# Все настройки камеры здесь

func _process(_delta):
	change_grid_position()
	
	if following_centre:
		position = get_node("../MassCentre").position
	elif not in_gui:
		if not Input.is_mouse_button_pressed(BUTTON_LEFT):
			drag_pos = get_global_mouse_position()
		else:
			position = drag_pos - get_local_mouse_position()


func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP and zoom > min_zoom:
				zoom *= 0.9
			if event.button_index == BUTTON_WHEEL_DOWN and zoom < max_zoom:
				zoom /= 0.9

func change_grid_position():
	var cam_x_shift = int(position.x) - (int(position.x) % 64)
	var cam_y_shift = int(position.y) - (int(position.y) % 64)
	grid.rect_position = Vector2(cam_x_shift - 4096, cam_y_shift - 4096)

func _on_CheckBox4_toggled(button_pressed):
	following_centre = button_pressed


func _on_Panel_mouse_entered():
	in_gui = true


func _on_TextureRect_mouse_entered():
	in_gui = false
