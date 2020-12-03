extends Node2D

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

remotesync func setup():
	for i in Server.players + 1:
		var player = preload("res://Fighter.tscn").instance()
		player.name = "PLAYER_" + str(i)
		player.position.x = 300 + i * 80
		player.fighter_id = i
		add_child(player)
	game_started = true
