extends KinematicBody2D

const FLOOR = Vector2(0, -1)
const SPEED = 30
const GRAVITY = 10

var move = true #может двигаться или нет
var is_alive = true #жив или мёртв
var velocity = Vector2()
var direction = 1
var health = 20
var toss = false
var target = null
var prev_pos
var cd_toss = 1.5
var jump = false

func _physics_process(delta):
	var pos = position
	$Label.text = str(health) #отображение количества hp
		
	if health <= 0: #проверка количества hp
		queue_free()
	elif jump == true:
		velocity.y = -200
		if direction == 1:
			velocity.x = 40
		else:
			velocity.x = -40
	elif is_alive == true and is_on_floor() and target == null and move: #обычное состояние вне битвы
		velocity.x = direction * SPEED
		
		if $RayCast_opinion.is_colliding():
			direction *= -1;
			$stump.flip_h = bool(1-direction);
		elif not $RayCast_legs.is_colliding():
			direction *= -1;
			$stump.flip_h = bool(1-direction)
			
# Управляет шейпами и лучами в зависимости от направления их взгляда
	if direction == 1:
		$enemy_hitBox.position.x = abs($enemy_hitBox.position.x) * -1
		$RayCast_legs.position.x = abs($RayCast_legs.position.x)
		$RayCast_opinion.position.x = abs($RayCast_opinion.position.x)
		$RayCast_jump.position.x = abs($RayCast_jump.position.x)
		$RayCast_jump.rotation_degrees = -90
		$Area_attack/attack.position.x = abs($Area_attack/attack.position.x)
		$RayCast_opinion.rotation_degrees = -90
		$stump.flip_h = true
	else:
		$enemy_hitBox.position.x = abs($enemy_hitBox.position.x)
		$RayCast_legs.position.x = abs($RayCast_legs.position.x) * -1
		$Area_attack/attack.position.x = abs($Area_attack/attack.position.x) * -1
		$RayCast_jump.position.x = abs($RayCast_jump.position.x) * -1
		$RayCast_jump.rotation_degrees = 90
		$RayCast_opinion.position.x = abs($RayCast_opinion.position.x) * -1
		$RayCast_opinion.rotation_degrees = 90
		$stump.flip_h = false
	search_for_target()
	velocity.y *= GRAVITY
	velocity = move_and_slide(velocity, FLOOR)
		
func search_for_target():
	var pl = get_parent().get_player()
	
	if toss == true: #подкидывание после пинка
		cd_toss -= 0.1
		move = false
		if G.player_direction == 1:
			velocity.x = 100
			velocity.y = - 100
		else:
			velocity.x = - 100
			velocity.y = - 100
		if cd_toss <= 0:
			velocity.x = 0
			$Timer_move.start(0.5)
			toss = false
			cd_toss = 1.5	
			
	elif position.distance_to(pl.position) < 40 or move == false:
		velocity.x = 0
		
	elif position.distance_to(pl.position) <= 100:
		target = pl
		$RayCast_jump.enabled = true
		$RayCast_opinion.enabled = false
		$RayCast_legs.enabled = false
		velocity = (pl.position - position)
		if velocity.x > 0:
			direction = 1
		else:
			direction = -1
			
	elif position.distance_to(pl.position) >= 300:
		move = false
		velocity.x = 0
		target = null
		$Timer_move.start(1)
		$RayCast_jump.enabled = false
		$RayCast_opinion.enabled = true
		$RayCast_legs.enabled = true
		
	if $RayCast_jump.is_colliding():
		jump = true
	else:
		jump = false
		
	if toss == true:
		velocity.y = -10
	else:
		velocity.y = 20

func _on_Area_attack_body_entered(body):
	if 'Player' in body.name:
		body.heath -= 1
		$Area_attack/attack.disabled = true
		
func _on_Timer_attack_timeout():
	move = true
	$Area_attack/attack.disabled = false





func _on_Timer_move_timeout():
	move = true
