extends KinematicBody2D

const FLOOR = Vector2(0, -1)
const SPEED = 30
const GRAVITY = 10

var player_spotted = false #видит ли враг игрока или нет
var move = true #может двигаться или нет
var is_alive = true #жив или мёртв
var velocity = Vector2()
var direction = 1
var health = 20
var toss = false
	
func _physics_process(delta):
	$Label.text = str(health) #отображение количества hp
	
	if health <= 0: #проверка количества hp
		queue_free()
		
	if toss == true: #подкидывание после пинка
		$Timer.start()
		if G.player_direction == 1:
			velocity.x = 100
			velocity.y = - 100
		else:
			velocity.x = - 100
			velocity.y = - 100
	elif is_alive == true and is_on_floor() and player_spotted == false: #обычное состояние вне битвы
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



func _on_Timer_timeout(): #таймер окончани подбрасывания
	toss = false
	move = true
