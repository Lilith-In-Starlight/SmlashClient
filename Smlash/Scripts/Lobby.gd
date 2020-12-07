extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	for i in range(1, 5):
		get_node("Players/Players" + str(i)).visible = (i <= Server.players)


