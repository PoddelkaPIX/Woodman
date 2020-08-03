extends KinematicBody2D

const JUMP = 350
const GRAVITY = 10
const FLOOR = Vector2(0, -1)

var speed_limit = 250
var velocity = Vector2()
var direction = 1
var spin = false
var jump = false
var kick = false
var attack = false
var hit = false
var cd_spin = 0
var cd_attack = 0

onready var Anim = $AnimationPlayer

func _physics_process(delta):
	cd_spin -= 1
	cd_attack -= 1
	if Input.is_action_just_pressed("E_pressed") and cd_attack <= 0:
		print(G.E_pressed)
		G.E_pressed = true
	if Input.is_action_just_pressed("ui_accept") and cd_attack <= 0:
		attack = true
	elif Input.is_action_just_pressed("ui_select") and cd_attack <= 0:
		kick = true
	
	if Input.is_action_pressed("ui_down") and cd_spin <= 0:
		spin = true
		$PlayerHitbox.disabled = true
	elif Input.is_action_pressed("ui_left") and spin == false:
		if velocity.x >= - speed_limit:
			velocity.x -= 15
		else:
			velocity.x = - speed_limit
		direction = -1
	elif Input.is_action_pressed("ui_right") and spin == false:
		if velocity.x <= speed_limit:
			velocity.x += 15
		else:
			velocity.x = speed_limit
		direction = 1
	
	if Input.is_action_pressed("ui_up") and is_on_floor():
		jump = true
		velocity.y = -JUMP
	else:
		if Input.is_action_just_released("ui_up") and velocity.y < -JUMP/2:
			velocity.y = -JUMP/2
	
	if spin == true:
		if direction == 1:
			velocity.x = + 400
		else:
			velocity.x = - 400
	elif attack == true:
		$Area2D/attack.disabled = false
	elif kick == true:
		$Area2D/kick.disabled = false
	
	if direction == 1:
		$PlayerHitbox.position.x = abs($PlayerHitbox.position.x) * -1
		$Area2D/attack.position.x = abs($Area2D/attack.position.x)
		$Area2D/kick.position.x = abs($Area2D/kick.position.x)
		$Sprite.flip_h = false
	else:
		$PlayerHitbox.position.x = abs($PlayerHitbox.position.x)
		$Area2D/attack.position.x = abs($Area2D/attack.position.x) * -1
		$Area2D/kick.position.x = abs($Area2D/kick.position.x) * -1
		$Sprite.flip_h = true
	
	velocity.y += GRAVITY
	velocity = move_and_slide(velocity, FLOOR)
	animation()

func animation():
	var anim
	if jump == true and not is_on_floor() and attack == false and kick == false and spin == false:
		anim = 'jump'
	elif velocity.y > 0 and attack == false and kick == false and spin == false:
		anim = 'fall'
	else:
		if spin == true:
			anim = 'spin'
		elif kick == true:
			anim = 'kick'
		elif attack == true:
			anim = 'attack1'
		elif Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
			anim = 'run'
		else:
			anim = 'idle'
	
	if anim == 'idle':
		velocity.x = 0
	
	if not Anim.play(anim):
		Anim.play(anim)

func _kick_end():
	cd_attack = 4
	kick = false
	$Area2D/kick.disabled = true

func _spin_end():
	cd_spin = 15
	if is_on_floor():
		spin = false
	$PlayerHitbox.disabled = false
	if is_on_floor():
		velocity.x = 0

func _attack_end():
	cd_attack = 4
	attack = false
	$Area2D/attack.disabled = true

func _jump_end():
	jump = false


