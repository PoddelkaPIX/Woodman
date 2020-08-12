extends CanvasLayer


func _process(delta):
	if G.axe_is_taken == true:
		$Control/axe.visible = true
	var hp_player = get_parent().heath
	$Control/hp_player.text = str(hp_player)
