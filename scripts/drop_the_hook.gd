extends KinematicBody2D

var speed = 450
var velosity = Vector2()
var returnn = false
var rotate_num = 0.3
var enter_the_player = false
var oneshot = true
var shells_twisting = 1
var uncoupling = false #отцепление
var stuck = false #застревание топора
var ret = false
var player

func _process(delta):
	G.axe_position = global_position
	
func _physics_process(delta):
	player = get_parent().get_player()
	rotate(rotate_num)
	
	if G.E_pressed == true:
		returnn = true
		
	if oneshot == true:
		velosity = ((G.mouse_position - position).normalized() * speed) * delta
		$Timer_fall_of_the_axe.start(0.3)
		oneshot = false
		
	if position.distance_to(G.player_position) < 70 and stuck == true:
		ret = true
	elif ret == true and position.distance_to(G.player_position) > 40:
		returnn = true
		
	if position.distance_to(G.player_position) > 225:
		returnn = true 
		
	if returnn == true:
		stuck = false
		rotate_num = 0.3
		if speed <= 1000:
			speed += 25
		velosity = ((G.player_position - position).normalized() * speed) * delta
	
	if position.distance_to(G.player_position) <= 10 and returnn == true:
		get_parent().get_player().shells += 1
		get_parent().get_player().lift = true
		get_parent().get_player().axe_in_hand = true
		get_parent().get_player().timer_shot()
		queue_free()
		
	if stuck:
		G.axe_stuck = true
		velosity = Vector2()
		rotate_num = 0
	else:
		G.axe_stuck = false
	translate(velosity)

func _on_Timer_fall_of_the_axe_timeout():
	var player = get_parent().get_player()
	if player.shift == false:
		enter_the_player = true
		velosity.y += 3
	else:
		rotate_num = 0
		


func _on_drop_the_hook_body_entered(body):
	if 'sticky' in body.name:
		stuck = true
	else:
		returnn = true
