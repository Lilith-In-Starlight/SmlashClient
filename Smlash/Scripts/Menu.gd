extends Control

enum MENUS {
	MAIN,
	LOBBY,
	MEET,
	OPTIONS,
	ELECTION
}

var current_menu = MENUS.MAIN



func _on_Join_pressed():
	Server.join("127.0.0.1")
	get_tree().connect("connected_to_server", self, "on_connected_ok")
	get_tree().connect("connection_failed", self, "on_connected_fail")
	get_tree().connect("server_disconnected", self, "on_server_disconnected")


func _on_Meet_pressed():
	pass


func _on_Options_pressed():
	pass


func _on_Election_pressed():
	pass


func _on_Leave_pressed():
	pass


func on_connected_ok():
	current_menu = MENUS.LOBBY

func on_server_disconnected():
	get_tree().disconnect("connected_to_server", self, "on_connected_ok")
	get_tree().disconnect("connection_failed", self, "on_connected_fail")
	get_tree().disconnect("server_disconnected", self, "on_server_disconnected")
	
func on_connected_fail():
	get_tree().disconnect("connected_to_server", self, "on_connected_ok")
	get_tree().disconnect("connection_failed", self, "on_connected_fail")
	get_tree().disconnect("server_disconnected", self, "on_server_disconnected")
