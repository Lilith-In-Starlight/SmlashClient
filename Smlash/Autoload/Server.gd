extends Node

var host := false
remotesync var players := 0
var local_id := -1
remotesync var inputs_0 := [false, false, false, false]
remotesync var inputs_1 := [false, false, false, false]
remotesync var inputs_2 := [false, false, false, false]
remotesync var inputs_3 := [false, false, false, false]

func start_host():
	host = true
	var peer := NetworkedMultiplayerENet.new()
	peer.create_server(5555, 8)
	get_tree().network_peer = peer
	local_id = 0
	get_tree().connect("network_peer_connected", self, "on_entity_join")
	get_tree().connect("network_peer_disconnected", self, "on_entity_leave")
	print("Host")

func join(ip):
	host = false
	var peer := NetworkedMultiplayerENet.new()
	peer.create_client(ip, 5555)
	get_tree().network_peer = peer
	get_tree().connect("connected_to_server", self, "on_connected_ok")
	get_tree().connect("connection_failed", self, "on_connected_fail")
	get_tree().connect("server_disconnected", self, "on_server_disconnected")
	print("Client")

# Server functions
func on_entity_join(id):
	print("Player joined with id: " + str(id))

func on_entity_leave(id):
	print("Player left with id: " + str(id))

remote func register_player():
	rset("players", players + 1)
	rpc_id(get_tree().get_rpc_sender_id(), "set_player_local_player", players)

# Cllient functions
func on_connected_ok():
	rpc_id(1, "register_player")
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
