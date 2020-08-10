extends KinematicBody2D

const GRAVITY = 10

var speed = 30
var stands = true
var destination = Vector2()
var velocity = Vector2()
var is_alive = true
var direction = 1
var prev_pos = Vector2()

func _process(delta):
	if velocity:
		prev_pos = position
		move_and_slide(velocity)
	wander()
	velocity.y += GRAVITY


		
func set_destination(dest):
	stands = false
	destination = dest
	velocity = (destination - position).normalized() * speed
	
func cancel_movement():
	velocity = Vector2()
	destination = Vector2()
	$standing.start(2)
	
func wander():
	var pos = position
	if stands:
		randomize()
		
		var x = int(rand_range(pos.x - 300, pos.x + 300))
		print(x)
		x = clamp(x, 0, 10000)
		set_destination(Vector2(x, position.y))
		
	elif velocity == Vector2():
		if pos.distance_to(destination) <= speed:
			cancel_movement()
		elif pos.distance_to(destination) <= 0.6:
			cancel_movement()
			
func _on_standing_timeout():
	stands = true
