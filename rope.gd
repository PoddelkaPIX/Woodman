extends Line2D

var point

func _process(delta):
	point = get_parent().position
	add_point(point)

	
