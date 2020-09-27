extends KinematicBody2D

const FLOOR = Vector2(0, -1)
const SPEED = 30
const JUMP = 350
const GRAVITY = 150

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
var jump_speed = -200
var attack_jump = false
var attack = false

func _physics_process(delta):
	var pos = position
	$Label.text = str(health) #отображение количества hp
	if target == null:
		$RayCast_legs.enabled = true
		$RayCast_opinion.enabled = true
	if health <= 0: #проверка количества hp
		queue_free()
		
	elif is_alive == true and is_on_floor() and target == null: #обычное состояние вне битвы
		velocity.x = direction * SPEED
		
		if $RayCast_opinion.is_colliding():
			direction *= -1;
			$stump.flip_h = bool(1-direction);
		elif not $RayCast_legs.is_colliding():
			direction *= -1;
			$stump.flip_h = bool(1-direction)
			
# Управляет шейпами и лучами в зависимости от направления их взгляда
	if direction == 1:
		$enemy_hitBox.position.x = abs($enemy_hitBox.position.x)
		$RayCast_legs.position.x = abs($RayCast_legs.position.x)
		$RayCast_opinion.position.x = abs($RayCast_opinion.position.x)
		$RayCast_jump.position.x = abs($RayCast_jump.position.x)
		$RayCast_jump.rotation_degrees = -90
		$Area_attack/attack.position.x = abs($Area_attack/attack.position.x)
		$StaticBody2D/CollisionShape2D.position.x = abs($StaticBody2D/CollisionShape2D.position.x)
		$RayCast_opinion.rotation_degrees = -90
		$stump.flip_h = true
	else:
		$enemy_hitBox.position.x = abs($enemy_hitBox.position.x) * -1
		$RayCast_legs.position.x = abs($RayCast_legs.position.x) * -1
		$Area_attack/attack.position.x = abs($Area_attack/attack.position.x) * -1
		$StaticBody2D/CollisionShape2D.position.x = abs($StaticBody2D/CollisionShape2D.position.x) * -1
		$RayCast_jump.position.x = abs($RayCast_jump.position.x) * -1
		$RayCast_jump.rotation_degrees = 90
		$RayCast_opinion.position.x = abs($RayCast_opinion.position.x) * -1
		$RayCast_opinion.rotation_degrees = 90
		$stump.flip_h = false
		
	search_for_target() 
	animation()
	jump()
	velocity = move_and_slide(velocity, FLOOR)

func turn(): #порот
	direction *= -1
	
func jump():
	var pl = get_parent().get_parent().get_player()
	if $RayCast_jump.is_colliding() and position.distance_to(pl.position) > 100 and is_on_floor():
		jump = true
		$RayCast_jump.enabled = true
		$Timer_fall.start(0.3)
		
	if jump == true:
		velocity.y = jump_speed
		jump_speed += 2
		
	elif jump == false:
		jump_speed = -200
		velocity.y += GRAVITY
		
func animation():
	var pl = get_parent().get_parent().get_player()
	if velocity.y < 0:
		$stump.play('jump')
	elif attack == true:
		$stump.play('attack')
	elif position.distance_to(pl.position) <= 200:
		$stump.play('run')
	else:
		$stump.play('walk')
		
func search_for_target():
	var pl = get_parent().get_parent().get_player()
	if position.distance_to(pl.position) < 40:
		attack = true
		
	if position.distance_to(pl.position) < 20 or move == false:
		velocity.x = 0
		
	elif position.distance_to(pl.position) <= 200:
		if (position.y - pl.position.y) < 80 and (position.y - pl.position.y) > -80:
			target = pl
			$RayCast_jump.enabled = true
			$RayCast_opinion.enabled = false
			$RayCast_legs.enabled = false
			if int(pl.position.x - position.x) > 0:
				velocity.x = SPEED * 4
			else:
				velocity.x = - SPEED * 4
				
			if velocity.x > 0:
				direction = 1
			else:
				direction = -1
			if (position.y - pl.position.y) > 20 and position.distance_to(pl.position) == 0:
				velocity.x = 0
	elif position.distance_to(pl.position) >= 400:
		target = null
		$RayCast_jump.enabled = false
		$RayCast_opinion.enabled = true
		$RayCast_legs.enabled = true
	if toss == true:
		velocity.y = -10
	else:
		velocity.y = 20

func _on_Area_attack_body_entered(body):
	if 'Player' in body.name:
		body.hit()
		$Area_attack/attack.disabled = true
		
func _on_Timer_attack_timeout():
	move = true
	$Area_attack/attack.disabled = true

func _on_Timer_fall_timeout():
	$RayCast_jump.enabled = false
	jump = false


func _on_stump_animation_finished():
	if $stump.animation == 'attack':
		attack = false
		$Area_attack/attack.disabled = false
		$Timer_attack.start(0.2)
		


func _on_Timer_attack_jump_timeout():
	attack_jump = false
