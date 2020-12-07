extends Control


onready var AllMenus := $"../"


func _on_Join_pressed():
	AllMenus.current_menu = AllMenus.MENUS.LOBBY
	AllMenus.update_menu()


func _on_Meet_pressed():
	pass


func _on_Options_pressed():
	pass


func _on_Election_pressed():
	pass


func _on_Leave_pressed():
	pass

