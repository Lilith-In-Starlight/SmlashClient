extends Control

var lobby_started := false
var game_started := false

func _ready():
	pass

func _process(delta):
	if not lobby_started:
		if Input.is_key_pressed(KEY_H):
			lobby_started = true
			
		elif Input.is_key_pressed(KEY_C):
			lobby_started = true
			
	elif not game_started:
		if Input.is_key_pressed(KEY_S):
			rpc("setup")

remotesync func setup():
	for i in Server.players:
		var player = preload("res://Fighter.tscn").instance()
		player.name = "PLAYER_" + str(i)
		player.position.x = 20 + i*30
		add_child(player)
	game_started = true
