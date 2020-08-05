extends Area2D

var key = 'Axe'
var label = 'Axe'
var desc = 'item_axe'
var count = 1
var icon = ''
	
func action():
	print('ACTION ', key )
func _process(delta):
	if (position.distance_to(G.player_position) < 50):
		$Label.visible = true
		if G.E_pressed == true:
			action()
	else:
		$Label.visible = false
