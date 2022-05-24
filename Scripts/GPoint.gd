extends Sprite

# Все характеристики точки здесь

signal clicked

export var mass = 0
export var active = true
export var color = Color(1, 1, 1)
export var velocity = Vector2.ZERO
var collided = false
var id = -1

func apply_color(clr=color):
	self_modulate = clr
	$Trail2D.default_color = clr
	$VelocityVector.default_color = clr.lightened(0.3)

func show_stats():
	$VelocityVector.visible = true
	$Label.visible = true
	$Label.text = str(id)

func hide_stats():
	$VelocityVector.visible = false
	$Label.visible = false

func update_velocity_vector():
	$VelocityVector.points[1] = velocity * 30

#func _input(event):
#	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
#		print(get_rect().position)
#		if get_rect().has_point(to_local(event.position)):
#			print("clicked")
#			emit_signal("clicked")
