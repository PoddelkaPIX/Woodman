extends Position2D

var velocity = Vector2()
var speed = 450

func _physics_process(delta):
	velocity = ((G.axe_position - position).normalized() * speed) * delta
	print(position)
	translate(velocity)
