extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass





func _on_Area2D_body_entered(body):
	if 'player' in body.name and G.E_pressed == true:
		$Area2D/CollisionShape2D.disabled == true
		G.E_pressed = false



func _on_Area2D2_body_shape_entered(body_id, body, body_shape, area_shape):
	if 'Player' in body.name and body_shape == 0:
		body.queue_free()
