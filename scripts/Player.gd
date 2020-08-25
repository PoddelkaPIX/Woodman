extends KinematicBody2D

const AXE = preload("res://scenes/drop_the_axe.tscn")
const HOOK = preload("res://scenes/drop_the_hook.tscn")
const rope = preload("res://scenes/rope.tscn")
const JUMP = 350
const FLOOR = Vector2(0, -1)

var shells = 1 #снаряды
var GRAVITY = 10
var speed_limit = 225 #ограничение по скорости игрока
var velocity = Vector2()
var direction = 1
var spin = false
var jump = false
var kick = false
var attack = false
var hit = false
var zoom = false
var shot = true
var turn = true #поворот
var shift = false
var twisting = false
var lift = true

var cd_spin = 0
var cd_attack = 0
var camera_zoom_x = 0.8
var camera_zoom_y = 0.8
var heath = 3
var anim

onready var Anim = $AnimationPlayer
onready var ui = get_viewport().get_node("res://scenes/UI.tscn")

func _ready():
	$Timers/camera_zoom.start()
	$Camera2D.set_zoom(Vector2(camera_zoom_x, camera_zoom_y))
	G.axe_is_taken = false
	$UI/Control/axe.visible = false

func _physics_process(delta):
	G.player_direction = direction #передаём в глобальную переменную сторону взгляда игрока
	cd_spin -= 1 * delta
	
	if heath <= 0:
		get_tree().reload_current_scene()
	
	if G.axe_is_taken == true:
		$Particles/CPUParticles2D.emitting = true
	
	if zoom == true:
		camera_zoom_x -= 0.5 * delta
		camera_zoom_y -= 0.5 * delta
		if camera_zoom_x > 0.4:
			$Camera2D.set_zoom(Vector2(camera_zoom_x, camera_zoom_y))
		else:
			zoom = false
	#кнопочки
	if Input.is_action_just_pressed("E_pressed"):
		G.E_pressed = true
		$Timers/looting_timer.start() #длительность нажатия клавиши Е = 0.1 сек
	
	if Input.is_action_just_pressed("ui_rmb") and shells > 0:
		if shot == true:
			if shot == true:
				shot = false
				$Timers/Timer_shot.start(0.5)
			shells -= 1
			G.mouse_position = get_global_mouse_position()
			var hook = HOOK.instance()
			hook.position = $Position_attack.global_position
			get_parent().add_child(hook)
			
	if Input.is_action_pressed("ui_shift") and cd_spin <= 0:
		shift = true
	else:
		shift = false
		
	if Input.is_action_pressed("ui_lmb") and shells > 0:
		if shot == true:
			if shot == true:
				shot = false
				$Timers/Timer_shot.start(0.5)
			shells -= 1
			G.mouse_position = get_global_mouse_position()
			var axe = AXE.instance()
			axe.position = $Position_attack.global_position
			get_parent().add_child(axe)
	elif Input.is_action_pressed("ui_down"):
		if Input.is_action_pressed("ui_accept"):
			$spin_attack/spin_attack_box.disabled = false
		
	if Input.is_action_pressed("ui_down") and cd_spin <= 0 and attack == false:
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
		$Timers/gravity_timer.start()
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
			velocity.x = + 300
		else:
			velocity.x = - 300
	
	if direction == 1:
		$PlayerHitbox.position.x = abs($PlayerHitbox.position.x) * -1
		$Particles/Particles_run.rotation_degrees = -77
		$Sprite.flip_h = false
	else:
		$PlayerHitbox.position.x = abs($PlayerHitbox.position.x)
		$Particles/Particles_run.rotation_degrees = 77
		$Sprite.flip_h = true
		
	velocity.y += GRAVITY
	twisting()
	velocity = move_and_slide(velocity, FLOOR)
	animation()
	
func twisting(): #скручивание
	if velocity.y < -10 and G.axe_stuck == true:
		velocity = (G.axe_position - position).normalized() * 400
		
		if lift == true and position.distance_to(G.axe_position) < 100:
			$Timers/lift_timer.start(0.1)
			velocity.y = -300

	
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
		$Particles/Particles_run.emitting = true
	else:
		$Particles/Particles_run.emitting = false
	if anim == 'idle':
		velocity.x = 0
	
	Anim.play(anim)

#функции окончания проигрывания анимаций
func _kick_end():
	turn = true
	cd_attack = 0.2
	kick = false

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

func _jump_end():
	jump = false

func _on_looting_timer_timeout(): #таймер выключающий нажатие на Е
	G.E_pressed = false

func _on_Area_Attack_body_entered(body): #свойства атаки
	if 'enemy' in body.name:
		velocity.x = 0
		if G.axe_is_taken == false: #обычная атака без усиления
			print('hit')
			body.health -= 5
		else: #атака с усилением
			body.health -= 10
		body.toss_attack = true
func _on_Area_kick_body_entered(body): #свойства пинка
	if 'enemy' in body.name:
		body.toss = true
		print('kick')
		body.health -= 1

func _on_gravity_timer_timeout():
	GRAVITY = 15

func _on_camera_zoom_timeout():
	zoom = true

func _on_ghost_trail_timeout():
	if spin == true:
		var trail = preload("res://scenes/GhostTrail.tscn").instance()
		trail.global_position = $Sprite.global_position
		trail.flip_h = $Sprite.flip_h
		trail.texture = $Sprite.texture
		trail.frame = $Sprite.frame
		get_tree().get_root().add_child(trail)
		trail.scale = $Sprite.scale


func _on_Timer_shot_timeout():
	shot = true


func _on_lift_timer_timeout():
	lift = false
