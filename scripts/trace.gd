extends Line2D
var point
func _ready():
	set_as_toplevel(true)
	
func _process(delta):
	point = get_parent().global_position
	add_point(point)
	if points.size() > 10:
		remove_point(0)
