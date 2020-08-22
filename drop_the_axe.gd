extends Area2D
var speed = 5
var velosity = Vector2()
var returnn = false

func _process(delta):
	rotate(0.6)
	if returnn == false:
		velosity = (G.mouse_position - position).normalized() * speed
	else:
		$CollisionShape2D.disabled = true
		if speed <= 20:
			speed += 0.5
		velosity = (G.player_position - position).normalized() * speed
		
	if position.distance_to(G.mouse_position) <= 5:
		returnn = true
	elif position.distance_to(G.player_position) <= 10 and returnn == true:
		get_parent().get_player().shells += 1
		queue_free()
		
	translate(velosity)



func _on_drop_the_axe_body_entered(body):
	if not 'Player' == body.name:
		returnn = true
	if 'enemy' in body.name:
		body.health -= 4
