extends Camera2D


func hit():
	$Timers/Timer_shot.start(0.4)
	$Timers/camera_zoom.start()
	
