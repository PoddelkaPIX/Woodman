extends KinematicBody2D

const JUMP = 350
const FLOOR = Vector2(0, -1)

var GRAVITY = 10
var speed_limit = 250 #ограничение по скорости игрока
var velocity = Vector2()
var direction = 1
var spin = false
var jump = false
var kick = false
var attack = false
var hit = false
var zoom = false
var cd_spin = 0
var cd_attack = 0
var camera_zoom_x = 0.8
var camera_zoom_y = 0.8
var heath = 3
var turn = true #поворот
var anim

onready var Anim = $AnimationPlayer
onready var ui = get_viewport().get_node("res://scenes/UI.tscn")

func _ready():
	$camera_zoom.start()
	$Camera2D.set_zoom(Vector2(camera_zoom_x, camera_zoom_y))
	G.axe_is_taken = false
	$UI/Control/axe.visible = false
	
func _physics_process(delta):
	G.player_direction = direction  #передаём в глобальную переменную сторону взгляда игрока
	cd_spin -= 1 * delta
	cd_attack -= 1 * delta
	
	if heath <= 0:
		get_tree().reload_current_scene()
		
		
	if G.axe_is_taken == true:
		$CPUParticles2D.emitting = true
		
	if zoom == true:
		camera_zoom_x -= 0.5 * delta
		camera_zoom_y -= 0.5 * delta
		if camera_zoom_x > 0.4:
			$Camera2D.set_zoom(Vector2(camera_zoom_x, camera_zoom_y))
		else:
			zoom = false
	 #кнопочки
	if Input.is_action_just_pressed("E_pressed") and cd_attack <= 0:
		G.E_pressed = true
		$looting_timer.start() #длительность нажатия клавиши Е = 0.1 сек
	
	if Input.is_action_just_pressed("ui_select") and cd_attack <= 0 and attack == false:
		kick = true
		turn = false
	elif Input.is_action_just_pressed("ui_accept") and cd_attack <= 0 and kick == false:
		attack = true
		turn = false
	if Input.is_action_pressed("ui_down") and cd_spin <= 0:
		spin = true
		set_collision_mask(1)
	elif Input.is_action_pressed("ui_left") and spin == false and turn:
		if velocity.x >= - speed_limit:
			velocity.x -= 15
		else:
			velocity.x = - speed_limit
		direction = -1
	elif Input.is_action_pressed("ui_right") and spin == false and turn:
		if velocity.x <= speed_limit:
			velocity.x += 15
		else:
			velocity.x = speed_limit
		direction = 1
	
	if Input.is_action_pressed("ui_up") and is_on_floor():
		$gravity_timer.start()
		jump = true
		velocity.y = -JUMP
	else:
		if Input.is_action_just_released("ui_up") and velocity.y < -JUMP/2:
			velocity.y = -JUMP/2
	
	if is_on_floor():
		GRAVITY = 10
	 #управление шейпами
	if spin == true:
		if direction == 1:
			velocity.x = + 400
		else:
			velocity.x = - 400
	elif attack == true:
		$Area_Attack/attack.disabled = false
	elif kick == true:
		$Area_kick/kick.disabled = false
	
	if direction == 1:
		$PlayerHitbox.position.x = abs($PlayerHitbox.position.x) * -1
		$Area_Attack/attack.position.x = abs($Area_Attack/attack.position.x)
		$Area_kick/kick.position.x = abs($Area_kick/kick.position.x)
		$Particles_run.rotation_degrees = -77
		$Sprite.flip_h = false
	else:
		$PlayerHitbox.position.x = abs($PlayerHitbox.position.x)
		$Area_Attack/attack.position.x = abs($Area_Attack/attack.position.x) * -1
		$Area_kick/kick.position.x = abs($Area_kick/kick.position.x) * -1
		$Particles_run.rotation_degrees = 77
		$Sprite.flip_h = true
	
	velocity.y += GRAVITY
	velocity = move_and_slide(velocity, FLOOR)
	animation()
 #машина состояний для анимации
func animation():
	if jump == true and not is_on_floor() and attack == false and kick == false and spin == false:
		anim = 'jump'
	elif jump == false and not is_on_floor() and attack == false and kick == false and spin == false:
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
	if anim == 'run':
		$Particles_run.emitting = true
	else:
		$Particles_run.emitting = false
	if anim == 'idle':
		velocity.x = 0
	
	Anim.play(anim)
#функции окончания проигрывания анимаций
func _kick_end():
	turn = true
	cd_attack = 0.2
	kick = false
	$Area_kick/kick.disabled = true

func _spin_end():
	set_collision_mask(5)
	spin = false
	cd_spin = 1
	if is_on_floor():
		velocity.x = 0

func _attack_end():
	turn = true
	cd_attack = 0.2
	attack = false
	$Area_Attack/attack.disabled = true

func _jump_end():
	jump = false

func _on_looting_timer_timeout(): #таймер выключающий нажатие на Е
	G.E_pressed = false

func _on_Area_Attack_body_entered(body): #свойства атаки
	if 'enemy' in body.name:
		if G.axe_is_taken == false: #обычная атака без усиления
			print('hit')
			body.health -= 5
		else: #атака с усилением
			body.health -= 10

func _on_Area_kick_body_entered(body): #свойства пинка
	if 'enemy' in body.name:
		body.toss = true
		print('kick')
		body.health -= 1

func _on_gravity_timer_timeout():
	GRAVITY = 15


func _on_camera_zoom_timeout():
	zoom = true
