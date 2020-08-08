extends Area2D

func _on_mushroom_body_entered(body):
	if 'Player' in body.name and body.velocity.y > 50:
		$AnimatedSprite.play('jump')
		body.velocity.y = -600
