extends Node2D

func _ready():
	OS.center_window()
func _process(delta):
	G.player_position = $Player.global_position

func _on_Area2D2_body_shape_entered(body_id, body, body_shape, area_shape):
	if 'Player' in body.name and body_shape == 0:
		get_tree().reload_current_scene()
