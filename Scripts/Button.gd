extends Button

onready var start_texture = load("res://textures/start.png")
onready var stop_texture = load("res://textures/stop.png")
var mode = "stopped"
signal sim_started
signal sim_ended

# Кнопка старт / стоп

func _on_Button_pressed():
	if mode == "stopped":
		icon = stop_texture
		mode = "started"
		emit_signal("sim_started")
	elif mode == "started":
		icon = start_texture
		mode = "stopped"
		emit_signal("sim_ended")

