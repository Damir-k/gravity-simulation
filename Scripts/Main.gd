extends Node2D

const V = Vector2(-0.93240737, -0.86473146) * 25.8
const P = Vector2(0.97000436, -0.24308753) * 300

var is_running = false
var last_id = 0
var editing_id = -1
var starting_settings = [
	[20, Vector2(0.97000436, -0.24308753) * 300, Vector2(-0.93240737, -0.86473146) * 25.8 * -0.5, Color.red],
	[20, -Vector2(0.97000436, -0.24308753) * 300, Vector2(-0.93240737, -0.86473146) * 25.8 * -0.5, Color.green],
	[20, Vector2(0, 0), Vector2(-0.93240737, -0.86473146) * 25.8, Color.yellow]
]

# Коммуницкация между частями проекта

func _ready():
	randomize()
	$GPoints.sim_speed = 0
	load_starting_settings()
	
	var err
	err = $CanvasLayer/Panel/HBoxContainer/Button.connect("sim_started", self, "_on_SimStarted")
	if err != OK: print(err)
	err = $CanvasLayer/Panel/HBoxContainer/Button.connect("sim_ended", self, "_on_SimEnded")
	if err != OK: print(err)

func load_starting_settings():
	for gp in $GPoints.get_children():
		gp.queue_free()
	
	last_id = 0
	for gp_setting in starting_settings:
		var new_gpoint = load("res://GPoint.tscn").instance()
		$GPoints.add_child(new_gpoint)
		
		new_gpoint.mass = gp_setting[0]
		new_gpoint.position = gp_setting[1]
		new_gpoint.velocity = gp_setting[2]
		last_id += 1
		new_gpoint.id = last_id
		new_gpoint.collided = false
		new_gpoint.connect("clicked", self, "_on_gpoint_clicked")
		
		new_gpoint.update_velocity_vector()
		new_gpoint.apply_color(gp_setting[3])
	
	allow_modifications()

func allow_modifications():
	is_running = false
	for gp in $GPoints.get_children():
		gp.show_stats()
	get_node("CanvasLayer/Panel/HBoxContainer/VBoxContainer3").visible = true

func disallow_modifications():
	is_running = true
	for gp in $GPoints.get_children():
		gp.hide_stats()
	get_node("CanvasLayer/Panel/HBoxContainer/VBoxContainer3").visible = false

func _on_CentreOfMass_toggled(button_pressed):
	$MassCentre.visible = button_pressed

func _on_Grid_toggled(button_pressed):
	$Grid.update_texture(button_pressed)

func _on_Trail_toggled(button_pressed):
	for gp in $GPoints.get_children():
		gp.get_node("Trail2D").visible = button_pressed

func _on_SimSpeed_value_changed(value):
	if not is_running:
		return
	
	if value == 0:
		$GPoints.sim_speed = 0
		for gp in $GPoints.get_children():
			gp.get_node("Trail2D").simulated = false
	else:
		$GPoints.sim_speed = pow(2, value - 6)
		for gp in $GPoints.get_children():
			gp.get_node("Trail2D").simulated = true

func _on_Gravity_value_changed(value):
	if value == 0:
		$GPoints.gravity = 0
	else:
		$GPoints.gravity = pow(2, value - 6)

func _on_SimEnded():
	$GPoints.sim_speed = 0
	load_starting_settings()

func _on_SimStarted():
	$GPoints.sim_speed = pow(2, $"CanvasLayer/Panel/HBoxContainer/VBoxContainer2/HSlider".value - 6)
	disallow_modifications()

func _on_AddGP_pressed():
	starting_settings.append([
		randi() % 100 + 1,
		Vector2(randi() % 500 - 250, randi() % 500 - 250),
		Vector2(randf() * 100 - 50, randf() * 100 - 50),
		Color(randf(), randf(), randf())
	])
	load_starting_settings()

func _on_RemoveGP_pressed():
	starting_settings.pop_back()
	load_starting_settings()


func _on_Object_text_entered(new_text):
	editing_id = int(new_text)


func _on_mass_text_entered(new_text):
	starting_settings[editing_id - 1][0] = int(new_text)
	load_starting_settings()

func _on_posX_text_entered(new_text):
	starting_settings[editing_id - 1][1].x = int(new_text)
	load_starting_settings()

func _on_posY_text_entered(new_text):
	starting_settings[editing_id - 1][1].y = int(new_text)
	load_starting_settings()

func _on_velX_text_entered(new_text):
	starting_settings[editing_id - 1][2].x = int(new_text)
	load_starting_settings()

func _on_velY_text_entered(new_text):
	starting_settings[editing_id - 1][2].y = int(new_text)
	load_starting_settings()

func _on_gpoint_clicked():
	print("clicked")
	#print(gp.position)

func set_starting_settings(name):
	if is_running:
		return
	
	if name == "8figure":
		starting_settings = [
			[20, Vector2(0.97000436, -0.24308753) * 300, Vector2(-0.93240737, -0.86473146) * 25.8 * -0.5, Color.red],
			[20, -Vector2(0.97000436, -0.24308753) * 300, Vector2(-0.93240737, -0.86473146) * 25.8 * -0.5, Color.green],
			[20, Vector2(0, 0), Vector2(-0.93240737, -0.86473146) * 25.8, Color.yellow]
		]
	elif name == "2bcircular":
		starting_settings = [
			[2500, Vector2.ZERO, Vector2(0, -1), Color.yellow],
			[10, Vector2(300, 0), Vector2(0, 290), Color.green]
		]
	elif name == "2belliptic":
		starting_settings = [
			[2500, Vector2.ZERO, Vector2(0, -1), Color.yellow],
			[10, Vector2(300, -300), Vector2(0, 290), Color.green]
		]
	elif name == "2bsymmetric":
		starting_settings = [
			[100, Vector2(-200, 0), Vector2(0, -30), Color.blue],
			[100, Vector2(200, 0), Vector2(0, 30), Color.green]
		]
	elif name == "2bspiral":
		starting_settings = [
			[50*4, Vector2(-250, -246), Vector2(28, -23), Color.royalblue],
			[29*4, Vector2(23, -224), Vector2(-19, 30), Color.chartreuse]
		]
	elif name == "2bknot":
		starting_settings = [
			[30, Vector2(313, 72), Vector2(-25, -46), Color.greenyellow],
			[55, Vector2(425, 38), Vector2(-41, 33), Color.purple]
		]
	elif name == "2bstrange":
		starting_settings = [
			[40, Vector2(313, 72)*2, Vector2(25, 46), Color.pink],
			[15, Vector2(425, 38), Vector2(41, 33), Color.aqua]
		]
	elif name == "3bsymmetric":
		starting_settings = [
			[15, Vector2(-100, 0), Vector2(-30*cos(PI/3), -30*sin(PI/3)), Color.red],
			[15, Vector2(100, 0), Vector2(-30*cos(PI/3), 30*sin(PI/3)), Color.green],
			[15, Vector2(0, -200 * sin(PI/3)), Vector2(30, 0), Color.blue]
		]
	elif name == "3btwinstar":
		starting_settings = [
			[400, Vector2(-200, 0), Vector2(0, -30), Color.blue],
			[400, Vector2(200, 0), Vector2(0, 30), Color.green],
			[10, Vector2(500, -300), Vector2(90, 90), Color.pink]
		]
	elif name == "3bSEM":
		starting_settings = [
			[50000, Vector2.ZERO, Vector2(0, -1), Color.yellow],
			[100, Vector2(1000, 0), Vector2(0, 800), Color.green],
			[20, Vector2(1040, 0), Vector2(0, 670), Color.darkgray]
		]
	else:
		starting_settings = []
	load_starting_settings()
