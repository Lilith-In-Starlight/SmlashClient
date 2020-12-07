extends Node2D


func _ready():
	for i in Server.players:
		var player = preload("res://Fighter.tscn").instance()
		player.name = "PLAYER_" + str(i)
		player.position.x = 300 + i * 80
		player.fighter_id = i + 1
		$Players.add_child(player)

func _process(delta):
#		if Server.host:
#			for i in Server.attacks.keys():
#				var ik = Server.attacks[i]
#				ik[3] += 1
#				if ik[3] >= 20:
#					Server.attacks.erase(i)
#					continue
#				for j in $Players.get_children():
#					if j != get_node(ik[0]):
#						if j.position.distance_to(get_node(ik[0]).position) < ik[2]:
#							Server.healths[j.fighter_id] += ik[1]
#							Server.rset_unreliable("healths", Server.healths)
#							Server.rpc_unreliable("set_player_speed", j.get_path(), j.position, (j.position-(get_node(ik[0]).position) + Vector2.DOWN * 5).normalized()*(((Server.healths[j.fighter_id]/100.0)*3000) + 300))

		for i in $Players.get_children():
			i.modulate = Color(1.0, 1.0 - (Server.player_data[i.fighter_id]["health"]/100.0), 1.0 - (Server.player_data[i.fighter_id]["health"]/100.0))
