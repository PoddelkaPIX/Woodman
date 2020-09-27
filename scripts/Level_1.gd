extends Node2D

func get_player():
	return $Player
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	OS.center_window() #при запуске отладки, окно центрируется на экране
func _process(delta):
	G.player_position = $Player.global_position #передаём глобальную позицию игрока
func _on_Area2D2_body_shape_entered(body_id, body, body_shape, area_shape):
	if 'Player' in body.name and body_shape == 0: # убивающая зона для отладки и её проверка
		get_tree().reload_current_scene()
