extends Control


onready var AllMenus := $"../"
onready var Start := $Start


func _process(delta):
	for i in range(1, 5):
		get_node("Players/Player" + str(i)).visible = (i <= Server.players)
	Start.disabled = (Server.local_id != 1)


func _on_Back_pressed():
	AllMenus.current_menu = AllMenus.MENUS.MAIN
	AllMenus.update_menu()


func _on_Start_pressed():
	Server.rpc_id(1, "start_game")
