extends RigidBody2D
var velocity = Vector2()

func _process(delta):
	velocity = (position - G.player_position).normalized()
	translate(velocity)
