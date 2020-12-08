extends AnimatedSprite


var go_to := Vector2(0, 0)

func _process(delta):
	var go_angle := global_position.angle_to_point(go_to) + PI/2
	rotation += (go_angle - rotation)
	
	var go_dist := global_position.distance_to(go_to)
	
	# TODO: I hate this way to do this. If I don't fix this in the future 
	# that means something went awfully wrong with my life
	if go_dist >= 19.0:
		frame = move_toward(frame, 0, 1)
	elif go_dist >= 18.0:
		frame = move_toward(frame, 1, 1)
	elif go_dist >= 17.0:
		frame = move_toward(frame, 2, 1)
	elif go_dist >= 16.0:
		frame = move_toward(frame, 3, 1)
	elif go_dist >= 15.0:
		frame = move_toward(frame, 4, 1)
	elif go_dist >= 14.0:
		frame = move_toward(frame, 5, 1)
	else:
		frame = move_toward(frame, 6, 1)
