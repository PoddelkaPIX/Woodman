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
	#target() 
	velocity.x
	move_and_slide(velocity)
	velocity.y += GRAVITY
			
func target():
	randomize()
	var pos = position
	var x = int(rand_range(pos.x - 300, pos.x + 300))
	print((x - position.x))
	velocity.x = (x - position.x) * speed
