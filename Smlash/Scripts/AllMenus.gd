extends Control


enum MENUS {
	MAIN,
	LOBBY,
	MEET,
	OPTIONS,
	ELECTION
}

onready var MainMenu := $MainMenu
onready var Lobby := $Lobby

onready var Join := $MainMenu/MenuOptions/Join
onready var Election := $MainMenu/MenuOptions/Election
onready var Meet := $MainMenu/MenuOptions/Meet

var current_menu = MENUS.MAIN


func _ready():
	Server.join("127.0.0.1")
	get_tree().connect("connected_to_server", self, "on_connected_ok")
	get_tree().connect("connection_failed", self, "on_connected_fail")
	get_tree().connect("server_disconnected", self, "on_server_disconnected")


func update_menu():
	match current_menu:
		MENUS.MAIN:
			only_visible_menu(MainMenu)
		MENUS.LOBBY:
			only_visible_menu(Lobby)


func only_visible_menu(Menu:Control):
	for i in get_children():
		i.visible = (i == Menu)


func on_connected_ok():
	Join.disabled = false
	Election.disabled = false
	Meet.disabled = false


func on_server_disconnected():
	get_tree().disconnect("connected_to_server", self, "on_connected_ok")
	get_tree().disconnect("connection_failed", self, "on_connected_fail")
	get_tree().disconnect("server_disconnected", self, "on_server_disconnected")
	
	
func on_connected_fail():
	get_tree().disconnect("connected_to_server", self, "on_connected_ok")
	get_tree().disconnect("connection_failed", self, "on_connected_fail")
	get_tree().disconnect("server_disconnected", self, "on_server_disconnected")
