extends Area2D

var speed = 450
var velosity = Vector2()
var returnn = false
var rotate_num = 0.3
var enter_the_player = false
var oneshot = true
var shells_twisting = 1
var uncoupling = false #отцепление
var player

func _physics_process(delta):
	player = get_parent().get_player()
	G.axe_position = global_position
	rotate(rotate_num)
		
	if oneshot == true:
		velosity = ((G.mouse_position - position).normalized() * speed) * delta
		$Timer_fall_of_the_axe.start(0.3)
		oneshot = false
		
	if position.distance_to(G.player_position) > 225:
		returnn = true 
		
	if returnn == true:
		if speed <= 1000:
			speed += 25
		velosity = ((G.player_position - position).normalized() * speed) * delta
		G.axe_velosity = false
	
	if position.distance_to(G.player_position) <= 10 and returnn == true:
		get_parent().get_player().shells += 1
		G.axe_position = Vector2()
		queue_free()
		
	translate(velosity)

func _on_drop_the_axe_body_entered(body):
	if not 'Player' == body.name:
		if shells_twisting == 0:
			returnn = true
			
		if player.shift == false:
			G.axe_velosity = false
			if 'Player' in body.name and enter_the_player == true:
				returnn = true
			if not 'Player' == body.name:
				returnn = true
		else:
			shells_twisting = 0
			G.axe_velosity = true
			velosity = Vector2()
			
		if 'enemy' in body.name:
			body.health -= 4

func _on_Timer_fall_of_the_axe_timeout():
	var player = get_parent().get_player()
	if player.shift == false:
		enter_the_player = true
		rotate_num = 0.15
		velosity.y += 5
	else:
		rotate_num = 0
		



func _on_uncoupling_timeout():
	uncoupling = true
