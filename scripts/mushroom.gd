extends Area2D
var toss = false
var jump = true
var pl

func _ready():
	pl = get_parent().get_parent().get_node("Player")
	randomize()
	var number = rand_range(0.2, 0.5)
	$Timer.start(number)
	
	
func _process(delta):
	if toss:
		pl.velocity = (($Sprite.global_position - pl.position).normalized()) * 400
		
	if jump == true:
		$AnimatedSprite.play('jump')
	else:
		$AnimatedSprite.play('idle')
		
		
func _on_mushroom_body_entered(body):
	if 'Player' in body.name and (body.velocity.y > 10 or body.velocity.y < -10):
		jump = true
		toss = true


func _on_AnimatedSprite_animation_finished():
	jump = false
	toss = false


func _on_Timer_timeout():
	jump = false
