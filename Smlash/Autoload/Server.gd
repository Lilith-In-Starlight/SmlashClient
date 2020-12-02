extends Node

var host := false

func start_host():
	host = true
	var peer := NetworkedMultiplayerENet.new()
	peer.create_server(5555, 8)
	get_tree().network_peer = peer
	get_tree().connect("connected_to_server", self, "on_connected_ok")
	get_tree().connect("connection_failed", self, "on_connected_fail")
	get_tree().connect("server_disconnected", self, "on_server_disconnected")

func join(ip):
	host = true
	var peer := NetworkedMultiplayerENet.new()
	peer.create_client(ip, 5555)
	get_tree().network_peer = peer
	get_tree().connect("network_peer_connected", self, "on_entity_join")
	get_tree().connect("network_peer_disconnected", self, "on_entity_leave")


# Server functions
func on_entity_join():
	pass

func on_entity_leave():
	pass


# Cllient functions
func on_connected_ok():
	pass

func on_server_disconnected():
	pass
	
func on_connected_fail():
	get_tree().disconnect("connected_to_server", self, "on_connected_ok")
	get_tree().disconnect("connection_failed", self, "on_connected_fail")
	get_tree().disconnect("server_disconnected", self, "on_server_disconnected")

