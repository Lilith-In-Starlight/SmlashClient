extends Node2D

enum ANIMS {
	idle,
	running
}


onready var FrontLeg := $FrontLeg
onready var BackLeg := $BackLeg
onready var FrontFoot := $FrontFoot
onready var BackFoot := $BackFoot

var current_anim = ANIMS.idle

var time := 0.0

func _process(delta):
	time += 1
	match current_anim:
		ANIMS.idle:
			FrontLeg.go_to = get_parent().global_position + Vector2(-10, 30) - Vector2.UP - position
			BackLeg.go_to = get_parent().global_position + Vector2(10, 30) - Vector2.UP - position
			FrontFoot.global_position += ((FrontLeg.go_to + position) - FrontFoot.global_position) / 2
			BackFoot.global_position += ((BackLeg.go_to + position) - BackFoot.global_position) / 2
			position.y += (abs(sin(time * 0.05) * 2) - position.y)/2
