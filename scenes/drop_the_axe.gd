extends Area2D
const SPEED = 10
var velosity = Vector2()
var returnn = false
func _process(delta):
	rotate(0.5)
	if returnn == false:
		velosity = (G.mouse_position - position).normalized() * SPEED
	else:
		velosity = (G.player_position - position).normalized() * SPEED
		
	if position.distance_to(G.mouse_position) <= 5:
		returnn = true
	elif position.distance_to(G.player_position) <= 5 and returnn == true:
		get_parent().get_player().shells += 1
		queue_free()
		
	translate(velosity)



func _on_drop_the_axe_body_entered(body):
	if not 'Player' == body.name:
		returnn = true
	if 'enemy' in body.name:
		body.health -= 5
