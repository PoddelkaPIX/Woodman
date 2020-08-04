extends Area2D

var item = 'Axe'
var amount = 1

func get_item():
	return item
	
func get_amount():
	return amount
	
func _process(delta):
	if (position.distance_to(G.player_position) < 50):
		$Label.visible = true
		if G.E_pressed == true:
			queue_free()
	else:
		$Label.visible = false
