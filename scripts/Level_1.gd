extends Node2D

func _on_Area2D_body_entered(body):
	if 'player' in body.name and G.E_pressed == true:
		$Area2D/CollisionShape2D.disabled == true
		G.E_pressed = false

func _on_Area2D2_body_shape_entered(body_id, body, body_shape, area_shape):
	if 'Player' in body.name and body_shape == 0:
		get_tree().reload_current_scene()
