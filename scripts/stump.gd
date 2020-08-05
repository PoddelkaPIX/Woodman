extends KinematicBody2D

const FLOOR = Vector2(0, -1)
const SPEED = 30
const GRAVITY = 10

var move = true
var is_alive = true
var velocity = Vector2()
var direction = 1
var health = 20
var toss = false
func _physics_process(delta):
	$Label.text = str(health)

	if health <= 0:
		queue_free()
	if toss == true:
		$Timer.start()
		if G.player_direction == 1:
			velocity.x = 100
			velocity.y = - 100
		else:
			velocity.x = - 100
			velocity.y = - 100
	elif is_alive == true and is_on_floor():
		velocity.x = direction * SPEED
		if $RayCast_opinion.is_colliding():
			direction *= -1;
			$stump.flip_h = bool(1-direction);
		elif not $RayCast_legs.is_colliding():
			direction *= -1;
			$stump.flip_h = bool(1-direction);
		
	if direction == 1:
		$enemy_hitBox.position.x = abs($enemy_hitBox.position.x) * -1
		$RayCast_legs.position.x = abs($RayCast_legs.position.x)
		$RayCast_opinion.position.x = abs($RayCast_opinion.position.x)
		$RayCast_opinion.rotation_degrees = -90
		$stump.flip_h = true
	else:
		$enemy_hitBox.position.x = abs($enemy_hitBox.position.x)
		$RayCast_legs.position.x = abs($RayCast_legs.position.x) * -1
		$RayCast_opinion.position.x = abs($RayCast_opinion.position.x) * -1
		$RayCast_opinion.rotation_degrees = 90
		$stump.flip_h = false
	
	velocity.y += GRAVITY
	velocity = move_and_slide(velocity, FLOOR)



func _on_Timer_timeout():
	toss = false
