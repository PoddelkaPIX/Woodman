extends KinematicBody2D

const FLOOR = Vector2(0, -1)
const SPEED = 30
const GRAVITY = 10

var animat
var move = true #может двигаться или нет
var is_alive = true #жив или мёртв
var velocity = Vector2()
var direction = 1
var health = 20
var toss = false
var toss_attack = false
var target = null
var prev_pos
var cd_toss = 1.5
var jump = false
var detonation = false
var explosion = false

func _physics_process(delta):
	var pl = get_parent().get_player()
	if position.distance_to(pl.position) <= 50:
		detonation = true
	elif position.distance_to(pl.position) <= 100:
		target = pl
		velocity = (pl.position - position)
		if velocity.x > 0:
			direction = 1
		else:
			direction = -1
	animation()
	velocity.y = GRAVITY
	velocity = move_and_slide(velocity, FLOOR)

func animation():
	if explosion == true:
		animat = 'boom'
	elif detonation == true:
		animat = 'detonation'
		$Timer_explosion.start(1.5)
	elif velocity.x != 0:
		animat = 'run'
	else:
		animat = 'idle'
	$anim.play(animat)

func _on_Timer_explosion_timeout():
	detonation = false
	explosion = true
