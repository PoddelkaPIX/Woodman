extends Area2D


func _process(delta):
	if (position.distance_to(G.player_position) < 50):
		$Label.visible = true
		if G.E_pressed == true:
			queue_free()
	else:
		$Label.visible = false
