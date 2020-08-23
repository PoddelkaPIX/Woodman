extends Area2D

var speed = 500
var velosity = Vector2()
var returnn = false
var rotate_num = 0.3
var enter_the_player = false
var oneshot = true
	

func _physics_process(delta):
	if oneshot == true:
		velosity = ((G.mouse_position - position).normalized() * speed) * delta
		$Timer_fall_of_the_axe.start(0.5)
		oneshot = false
	rotate(rotate_num)
	if position.distance_to(G.player_position) > 225:
		returnn = true 
	if returnn == true:
		if speed <= 1000:
			speed += 25
		velosity = ((G.player_position - position).normalized() * speed) * delta
	
	if position.distance_to(G.player_position) <= 10 and returnn == true:
		get_parent().get_player().shells += 1
		queue_free()
	
	translate(velosity)

func _on_drop_the_axe_body_entered(body):
	if 'Player' in body.name and enter_the_player == true:
		returnn = true
	if not 'Player' == body.name:
		returnn = true
	if 'enemy' in body.name:
		body.health -= 4

func _on_Timer_fall_of_the_axe_timeout():
	enter_the_player = true
	rotate_num = 0.15
	velosity.y += 4

func _on_Timer_timeout():
	oneshot = false
