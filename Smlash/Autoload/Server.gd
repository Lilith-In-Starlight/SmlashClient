extends Node

const STAGE := preload("res://Scenes/Lobby.tscn")

remotesync var players := 0

var host := false
var local_id := -1
var attacks := {}
var attacks_ever := 0
var player_data := {
	
}

var local_data := {
	"health" : 0.0,
	"position" : Vector2(0, 0),
	"cspeed" : 0.0,
}

func join(ip):
	host = false
	var peer := NetworkedMultiplayerENet.new()
	peer.create_client(ip, 5555)
	get_tree().network_peer = peer
	get_tree().connect("connected_to_server", self, "on_connected_ok")
	get_tree().connect("connection_failed", self, "on_connected_fail")
	get_tree().connect("server_disconnected", self, "on_server_disconnected")
	print("Client")

# Cllient functions
func on_connected_ok():
	rpc_id(1, "register_player", local_data)
	print("Conncted")

func on_server_disconnected():
	print("Server disconnected")
	
func on_connected_fail():
	get_tree().disconnect("connected_to_server", self, "on_connected_ok")
	get_tree().disconnect("connection_failed", self, "on_connected_fail")
	get_tree().disconnect("server_disconnected", self, "on_server_disconnected")
	print("Fail")

remote func set_player_local_player(lpid):
	local_id = lpid

remotesync func update_player_data_from_server(data):
	player_data = data

remote func update_player_data(data):
	player_data = data

remote func go_to_lobby():
	get_tree().change_scene_to(STAGE)
