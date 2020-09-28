extends KinematicBody2D

const FLOOR = Vector2(0, -1)

var direction = 1
var gravity = 5
var velocity = Vector2()
var speed = 60
var max_speed = 90
var health = 20
var damage = 1
var is_live = true
var push = false #толчок
var idle = false
var target = null
var run = false
var stop = false
var walk = true
var attack = false
var jump_attack = false
var preparation_jump_attack = false
var stun = false
var jump = false
var turn = false #поворот

func _physics_process(_delta):
	$Label.text = str(jump) + ' '
	$Label.text += str(target) + ' '
	if health <= 0:
		death()
	if is_live and stun == false and idle == false and \
	target == null and turn == false:
		velocity.x = direction * speed
	if velocity.x > 20 and target == 'player':
		direction = 1
	elif velocity.x < 20 and target == 'player':
		direction = -1
	velocity.y += gravity
	pursuit()
	actions()
	animations()
	tracking()
	velocity = move_and_slide(velocity, FLOOR)
	
func animations():
	if target == 'player':
		$Anim.play('run')
	elif target == null:
		$Anim.play('walk')
	if stop == true or (run == false and walk == false):
		$Anim.play('stop')
	if target == 'player' and jump == true:
		$Anim.play('jump')
		
func tracking():
	if target == null:
		if not $RayCast_floor.is_colliding() and is_on_floor() or\
			 $RayCast_eyes.is_colliding() and is_on_floor() and velocity.x != 0:
				direction *= -1
	if $RayCast_eyes.is_colliding() and target == 'player':
		$RayCast_eyes.enabled = false
		if stop == false:
			$Timers/Timer_stop.start(0.5)
			stop = true
	if direction == 1:
		$CollisionShape.position.x = abs($CollisionShape.position.x)
		$RayCast_floor.position.x = abs($RayCast_floor.position.x)
		$RayCast_eyes.position.x = abs($RayCast_eyes.position.x)
		$RayCast_eyes.rotation_degrees = -90
		$Anim.flip_h = true
	else:
		$CollisionShape.position.x = abs($CollisionShape.position.x) * -1
		$RayCast_floor.position.x = abs($RayCast_floor.position.x) * -1
		$RayCast_eyes.position.x = abs($RayCast_eyes.position.x) * -1
		$RayCast_eyes.rotation_degrees = 90
		$Anim.flip_h = false
			
func actions():
	if jump == true:
		velocity.y = - 160
	if stop == true:
		velocity.x = 0
		
func stump_turn():
	if turn == true:
		velocity.x = 0
		$Timers/turn_timer.start(0.7)
		
func jump():
	$Timers/Timer_jump.start(0.199)
	
	
func pursuit(): #преследование
	var pl = get_parent().get_parent().get_player()
	if position.distance_to(pl.position) < 200 and target == null:
		target = 'player'
		run = true
		walk = false
	elif target == 'player':
		if int(pl.position.x - position.x) > 10:
			direction = 1
			velocity.x =  max_speed
		elif int(pl.position.x - position.x) < -10:
			direction = -1
			velocity.x = - max_speed
	if position.distance_to(pl.position) <= 50:
		velocity.x = 0
		run = false
	else:
		run = true
		
func _on_turn_timer_timeout():
	direction *= -1
	turn = false

func _on_Timer_jump_timeout():
	jump = false
	$Timers/Timer_enable_eyes.start(1)

func death():
	queue_free()

func _on_Timer_stop_timeout():
	if is_on_floor():
		jump()
		jump = true
	stop = false


func _on_Timer_enable_eyes_timeout():
	$RayCast_eyes.enabled = true
