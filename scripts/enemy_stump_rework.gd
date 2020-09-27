extends KinematicBody2D

const FLOOR = Vector2(0, -1)

var direction = 1
var gravity = 5
var velocity = Vector2()
var speed = 30
var max_speed = 60
var health = 20
var damage = 1
var is_live = true
var push = false #толчок
var idle = false
var target = null
var run = false
var walk = false
var attack = false
var jump_attack = false
var preparation_jump_attack = false
var stun = false
var jump = false
var turn = false #поворот

func _physics_process(_delta):
	$Label.text = str(target)
	if health <= 0:
		death()
	if is_live and stun == false and idle == false and \
	target == null and turn == false:
		if not $RayCast_floor.is_colliding() or $RayCast_eyes.is_colliding():
			direction *= -1
		velocity.x = direction * speed
	if direction == 1:
		$CollisionShape.position.x = abs($CollisionShape.position.x)
		$RayCast_floor.position.x = abs($RayCast_floor.position.x)
		$RayCast_eyes.position.x = abs($RayCast_eyes.position.x)
		$Anim.flip_h = true
	else:
		$CollisionShape.position.x = abs($CollisionShape.position.x) * -1
		$RayCast_floor.position.x = abs($RayCast_floor.position.x) * -1
		$RayCast_eyes.position.x = abs($RayCast_eyes.position.x) * -1
		$Anim.flip_h = false
	velocity.y += gravity
	pursuit()
	velocity = move_and_slide(velocity)
	
func death():
	queue_free()
	
func pursuit(): #преследование
	var pl = get_parent().get_parent().get_player()
	if position.distance_to(pl.position) < 200 and target == null:
		target = 'player'
	elif position.distance_to(pl.position) > 300:
		target = null
	elif target == 'player':
		if int(pl.position.x - position.x) > 0:
			velocity.x =  max_speed
		else:
			velocity.x = - max_speed

func stump_turn():
	if turn == true:
		velocity.x = 0
		$Timers/turn_timer.start(1)

func _on_turn_timer_timeout():
	direction *= -1
	turn = false

func jump():
	if velocity.y > 100:
		velocity.y -= 10
