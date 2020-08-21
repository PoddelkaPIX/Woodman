extends Area2D
var jump = false
func _process(delta):
	if jump == true:
		$AnimatedSprite.play('jump')
	else:
		$AnimatedSprite.play('idle')
func _on_mushroom_body_entered(body):
	if 'Player' in body.name and body.velocity.y > 50:
		jump = true
		body.velocity.y = -560


func _on_AnimatedSprite_animation_finished():
	jump = false
