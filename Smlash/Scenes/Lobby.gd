extends Control

var lobby_started := false
var game_started := false

func _ready():
	pass

func _process(delta):
	if not lobby_started:
		if Input.is_key_pressed(KEY_H):
			Server.start_host()
			lobby_started = true
			
		elif Input.is_key_pressed(KEY_C):
			Server.join("fdfd::1af4:a824")
			lobby_started = true
			
	elif not game_started:
		if Input.is_key_pressed(KEY_S):
			rpc("setup")
	
	elif not Server.host:
		var pl
		match Server.local_id:
			0:
				pl = Server.inputs_0.duplicate()
			1:
				pl = Server.inputs_1.duplicate()
			2:
				pl = Server.inputs_2.duplicate()
			3:
				pl = Server.inputs_3.duplicate()
		pl[0] = Input.is_key_pressed(KEY_RIGHT)
		pl[1] = Input.is_key_pressed(KEY_LEFT)
		pl[2] = Input.is_key_pressed(KEY_UP)
		pl[3] = Input.is_key_pressed(KEY_DOWN)
		match Server.local_id:
			0:
				Server.rset_unreliable("inputs_0", pl)
				if pl[0]:
					get_node("PLAYER_0").rect_position.x += 5
				if pl[1]:
					get_node("PLAYER_0").rect_position.x -= 5
				if pl[2]:
					get_node("PLAYER_0").rect_position.y -= 5
				if pl[3]:
					get_node("PLAYER_0").rect_position.y += 5
			1:
				Server.rset_unreliable("inputs_1", pl)
				if pl[0]:
					get_node("PLAYER_1").rect_position.x += 5
				if pl[1]:
					get_node("PLAYER_1").rect_position.x -= 5
				if pl[2]:
					get_node("PLAYER_1").rect_position.y -= 5
				if pl[3]:
					get_node("PLAYER_1").rect_position.y += 5
			2:
				Server.rset_unreliable("inputs_2", pl)
				if pl[0]:
					get_node("PLAYER_2").rect_position.x += 5
				if pl[1]:
					get_node("PLAYER_2").rect_position.x -= 5
				if pl[2]:
					get_node("PLAYER_2").rect_position.y -= 5
				if pl[3]:
					get_node("PLAYER_2").rect_position.y += 5
			3:
				Server.rset_unreliable("inputs_3", pl)
				if pl[0]:
					get_node("PLAYER_3").rect_position.x += 5
				if pl[1]:
					get_node("PLAYER_3").rect_position.x -= 5
				if pl[2]:
					get_node("PLAYER_3").rect_position.y -= 5
				if pl[3]:
					get_node("PLAYER_3").rect_position.y += 5
	else:
		print(Server.players)
		Server.inputs_0[0] = Input.is_key_pressed(KEY_RIGHT)
		Server.inputs_0[1] = Input.is_key_pressed(KEY_LEFT)
		Server.inputs_0[2] = Input.is_key_pressed(KEY_UP)
		Server.inputs_0[3] = Input.is_key_pressed(KEY_DOWN)
		if Server.inputs_0[0]:
			get_node("PLAYER_0").rect_position.x += 5
		if Server.inputs_0[1]:
			get_node("PLAYER_0").rect_position.x -= 5
		if Server.inputs_0[2]:
			get_node("PLAYER_0").rect_position.y -= 5
		if Server.inputs_0[3]:
			get_node("PLAYER_0").rect_position.y += 5
		
		if Server.players >= 0:
			if Server.inputs_1[0]:
				get_node("PLAYER_1").rect_position.x += 5
			if Server.inputs_1[1]:
				get_node("PLAYER_1").rect_position.x -= 5
			if Server.inputs_1[2]:
				get_node("PLAYER_1").rect_position.y -= 5
			if Server.inputs_1[3]:
				get_node("PLAYER_1").rect_position.y += 5
		
		if Server.players > 2:
			if Server.inputs_2[0]:
				get_node("PLAYER_2").rect_position.x += 5
			if Server.inputs_2[1]:
				get_node("PLAYER_2").rect_position.x -= 5
			if Server.inputs_2[2]:
				get_node("PLAYER_2").rect_position.y -= 5
			if Server.inputs_2[3]:
				get_node("PLAYER_2").rect_position.y += 5
		rpc_unreliable("update_pos_on_clients", "PLAYER_0", get_node("PLAYER_0").rect_position)
		rpc_unreliable("update_pos_on_clients", "PLAYER_1", get_node("PLAYER_1").rect_position)

remotesync func setup():
	for i in Server.players + 1:
		var player = preload("res://Fighter.tscn").instance()
		player.name = "PLAYER_" + str(i)
		player.rect_position.x = 20 + i*30
		add_child(player)
	game_started = true

remotesync func update_pos_on_clients(player, pos):
	get_node(player).rect_position = pos
