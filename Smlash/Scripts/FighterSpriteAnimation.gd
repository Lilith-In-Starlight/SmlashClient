extends Node2D

enum ANIMS {
	idle,
	running
}


onready var FrontLeg := $FrontLeg
onready var BackLeg := $BackLeg

var current_anim = ANIMS.idle

var time := 0.0

func _process(delta):
	time += 1
	match current_anim:
		ANIMS.idle:
			FrontLeg.go_to = global_position + Vector2(-12, -30) - Vector2.UP * sin(time * 0.01) * 3
			BackLeg.go_to = global_position + Vector2(12, -30) - Vector2.UP * sin(time * 0.01) * 3
			position.y = sin(time * 0.01) * 3
