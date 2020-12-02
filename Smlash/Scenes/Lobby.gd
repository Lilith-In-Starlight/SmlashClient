extends Control


var lobby_started := false

func _ready():
	pass

func _process(delta):
	if not lobby_started:
		if Input.is_key_pressed(KEY_H):
			lobby_started = true
			
		elif Input.is_key_pressed(KEY_C):
			lobby_started = true

