extends Sprite


func _ready():
	$Tween.interpolate_property(self, "modulate", Color(.5, .5, .5, 1), Color(.5, .5, .5, 0), .6, Tween.TRANS_SINE, Tween.EASE_OUT)
	$Tween.start()
	yield($Tween, "tween_completed")
	queue_free()
