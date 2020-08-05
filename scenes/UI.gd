extends CanvasLayer


func _process(delta):
	if G.axe_is_taken == true:
		$Control/axe.visible = true
