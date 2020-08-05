extends Area2D

var key = 'Axe'
var label = 'Axe'
var desc = 'item_axe'
var count = 1
var icon = ''
	
func _process(delta):
	if (position.distance_to(G.player_position) < 50):
		if G.E_pressed == true:
			queue_free()
			G.axe_is_taken = true
