extends Node

onready var centre = get_node("../MassCentre")
onready var sim_speed_slider = get_node("../CanvasLayer/Panel/HBoxContainer/VBoxContainer2/HSlider")

var world_scale = 100
var gravity = 1
var sim_speed = 1
var min_dst = 10

# Симуляция целиком здесь

func calculate_v(gp1, gp2):
	return (gp1.mass * gp1.velocity + gp2.mass * gp2.velocity) / float(gp1.mass + gp2.mass)

func calculate_p(gp1, gp2):
	return (gp1.mass * gp1.position + gp2.mass * gp2.position) / float(gp1.mass + gp2.mass)

func force_on(gp1, gp2):
	if not gp1.active or not gp2.active or gp1 == gp2:
		return Vector2.ZERO
	var dst = (gp1.position - gp2.position).length() / world_scale
	var absF = gravity * gp1.mass * gp2.mass / pow(dst, 2)
	var F = absF * Vector2.RIGHT.rotated(gp1.get_angle_to(gp2.position))
	return F

func process_velocity(gp1, dt):
	var F_total = Vector2.ZERO
	for gp2 in get_children():
		var f = force_on(gp1, gp2)
		F_total += f
	var acceleration = F_total / float(gp1.mass)
	gp1.velocity += acceleration * dt * sim_speed

func process_collision(gp1, gp2):
	var l = (gp1.position - gp2.position).length()
	if l <= min_dst:
		var average_vel = calculate_v(gp1, gp2)
		var average_pos = calculate_p(gp1, gp2)
		gp1.position = average_pos
		gp1.velocity = average_vel
		gp1.mass = gp1.mass + gp2.mass
		
		gp2.mass = 0
		gp2.active = false
		gp2.visible = false
		gp2.queue_free()

func process_position(gp, dt):
	gp.position += gp.velocity * dt * sim_speed

func get_centre_position(g_points):
	if len(g_points) == 0: return Vector2.ZERO
	var w_sum = Vector2.ZERO
	var m_sum = 0
	
	for gp in g_points:
		if gp.active:
			m_sum += gp.mass
			w_sum += gp.position * gp.mass
	
	return w_sum / float(m_sum)

func _physics_process(delta):
	centre.position = get_centre_position(get_children())
	if sim_speed > 0:
		
		
		for gp in get_children():
			process_position(gp, delta)
		
		var ch = get_children()
		ch.shuffle()
		while len(ch) > 0:
			var gp1 = ch.pop_front()
			for gp2 in ch:
				process_collision(gp1, gp2)
		
		for gp in get_children():
			process_velocity(gp, delta)
