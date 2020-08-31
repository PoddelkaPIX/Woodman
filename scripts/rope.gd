extends Line2D


func _process(delta):
	add_point(Vector2(G.player_position.x - 200, G.player_position.y))
	add_point(get_global_mouse_position())
