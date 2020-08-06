extends Area2D
	
func _process(delta):
#Если игрок подошёл слишком близко к топору и нажал E, то топор удаляется и выдаётся в инвентарь. 
	if (position.distance_to(G.player_position) < 50): #Смотрим, чтобы игрок подошёл на расстояние меньше чем 50 px
		if G.E_pressed == true:
			queue_free()
			G.axe_is_taken = true
