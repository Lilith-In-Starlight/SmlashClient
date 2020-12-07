extends Node2D


func _ready():
	for i in range(1, Server.players+1):
		var player = preload("res://Fighter.tscn").instance()
		player.name = "PLAYER_" + str(i)
		print(player.name)
		player.position.x = 300 + i * 80
		player.fighter_id = i
		$Players.add_child(player)

func _process(delta):
	var local_fighter := get_node("Players/PLAYER_" + str(Server.local_id))
	
#	Server.rpc_unreliable("set_player_speed", j.get_path(), j.position, (j.position-(get_node(ik[0]).position) + Vector2.DOWN * 5).normalized()*(((Server.healths[j.fighter_id]/100.0)*3000) + 300))
	
	for i in $Players.get_children():
		i.modulate = Color(1.0, 1.0 - (Server.player_data[i.fighter_id]["health"]/100.0), 1.0 - (Server.player_data[i.fighter_id]["health"]/100.0))
		
		if local_fighter != i and local_fighter.time_since_attack > 0:
			Server.rpc_unreliable_id(1, "damage_player", Server.local_id, i.fighter_id, local_fighter.position, i.position, 0.1)
