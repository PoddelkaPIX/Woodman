extends Node2D


func _process(delta):
	position = get_global_mouse_position()
	if position.distance_to(G.player_position) <= 200:
		$AnimatedSprite.play('white')
	else:
		$AnimatedSprite.play('red')
