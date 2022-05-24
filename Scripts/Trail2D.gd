extends Line2D

export var length = 200
var point = Vector2.ZERO
var parent_scale
var simulated = true

func _process(_delta):
	if simulated:
		global_position = Vector2.ZERO
		global_rotation = 0
		parent_scale = get_parent().scale.x
		scale = Vector2(1 / parent_scale, 1 / parent_scale)
		
		point = get_parent().position
		add_point(point)
		while get_point_count() > length:
			remove_point(0)
