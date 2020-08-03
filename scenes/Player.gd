extends KinematicBody2D

const jump = 350
const GRAVITY = 10
const Floor = Vector2(0, -1)
var speed_limit = 250
var velocity = Vector2()
var move = false
var directyon = 1
var Move = false
var spin = false
var Jump = false
var kick_fut = false
var attack = false
var hit = false
var cd_spin = 0
var cd_attack = 0
onready var timer = get_node("Timer")

func _physics_process(delta):
	cd_spin -= 1
	cd_attack -= 1
	if Input.is_action_just_pressed("E_pressed") and cd_attack <= 0:
		print(G.E_pressed)
		G.E_pressed = true
	if Input.is_action_just_pressed("ui_accept") and cd_attack <= 0:
		attack = true
	elif Input.is_action_just_pressed("ui_select") and cd_attack <= 0:
		kick_fut = true
		
	if Input.is_action_pressed("ui_down") and cd_spin <= 0:
		spin = true
		$CollisionShape2D.disabled = true
	elif Input.is_action_pressed("ui_left") and $anim.animation != 'spin':
		if velocity.x >= - speed_limit:
			velocity.x -= 15
		else:
			velocity.x = - speed_limit
		directyon = -1
	elif Input.is_action_pressed("ui_right") and $anim.animation != 'spin':
		if velocity.x <= speed_limit:
			velocity.x += 15
		else:
			velocity.x = speed_limit
		directyon = 1
		
	if Input.is_action_pressed("ui_up") and is_on_floor():
		Jump = true
		velocity.y = -jump
		
	if spin == true:
		if directyon == 1:
			velocity.x = + 400
		else:
			velocity.x = - 400
	elif attack == true:
		$Area2D/attack.disabled = false
	elif kick_fut == true:
		$Area2D/Kick_fut.disabled = false
		
	if directyon == 1:
		$CollisionShape2D.position.x = abs($CollisionShape2D.position.x) * -1
		$Area2D/attack.position.x = abs($Area2D/attack.position.x)
		$Area2D/Kick_fut.position.x = abs($Area2D/Kick_fut.position.x)
		$anim.flip_h = false
	else:
		$CollisionShape2D.position.x = abs($CollisionShape2D.position.x)
		$Area2D/attack.position.x = abs($Area2D/attack.position.x) * -1
		$Area2D/Kick_fut.position.x = abs($Area2D/Kick_fut.position.x) * -1
		$anim.flip_h = true
		
	velocity.y += GRAVITY
	velocity = move_and_slide(velocity, Floor)
	animation()
	
func animation():
	var anim
	if Jump == true:
		anim = 'jump'
	elif velocity.y > 0 and not $RayCast2D.is_colliding() and attack == false:
		anim = 'fall'
	else:
		if spin == true:
			anim = 'spin'
		elif kick_fut == true:
			anim = 'kick_fut'
		elif attack == true:
			anim = 'attack1'
		elif Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
			anim = 'run'
		else:
			anim = 'idle'
			
	if anim == 'idle':
		velocity.x = 0
		
	if $anim.animation != anim:
		$anim.play(anim)

func _on_anim_animation_finished():
	if $anim.animation == 'kick_fut':
		cd_attack = 4
		kick_fut = false
		$Area2D/Kick_fut.disabled = true
	if $anim.animation == 'spin':
		cd_spin = 15
		$CollisionShape2D.disabled = false
		spin = false
		$CollisionShape2D.disabled = false
		if $RayCast2D.is_colliding():
			velocity.x = 0
				
	if $anim.animation == 'attack1':
		cd_attack = 4
		attack = false
		$Area2D/attack.disabled = true
		
	if $anim.animation == 'jump':
		Jump = false
