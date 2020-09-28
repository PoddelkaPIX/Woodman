extends Area2D

var speed = 450
var velocity = Vector2()
var returnn = false
var rotate_num = 0.3
var enter_the_player = false
var oneshot = true
var shells_twisting = 1
var uncoupling = false #отцепление
var player

func _process(delta):
	G.axe_position = global_position
	
func _physics_process(delta):
	player = get_parent().get_player()
	rotate(rotate_num)
		
	if oneshot == true:
		velocity = ((G.mouse_position - position).normalized() * (speed + 100)) * delta
		$Timer_fall_of_the_axe.start(0.3)
		oneshot = false
		
	if position.distance_to(G.player_position) > 180:
		returnn = true 
		
	if returnn == true:
		if speed <= 1000:
			speed += 25
		velocity = ((G.player_position - position).normalized() * (speed - 100)) * delta
	
	if position.distance_to(G.player_position) <= 10 and returnn == true:
		get_parent().get_player().shells += 1
		get_parent().get_player().axe_in_hand = true
		get_parent().get_player().timer_shot()
		queue_free()
		
	translate(velocity)

func _on_drop_the_axe_body_entered(body):
	if not 'Player' in body.name:
		returnn = true
			
	if 'enemy' in body.name:
		get_parent().get_player().camera_hit()
		body.health -= 4

func _on_Timer_fall_of_the_axe_timeout():
	var player = get_parent().get_player()
	if player.shift == false:
		enter_the_player = true
		rotate_num = 0.15
		velocity.y += 3
	else:
		rotate_num = 0
