extends Node2D

enum ANIMS {
	idle,
	running,
	jumping,
	falling,
}


onready var FrontLeg := $FrontLeg
onready var BackLeg := $BackLeg
onready var FrontFoot := $FrontFoot
onready var BackFoot := $BackFoot

var current_anim = ANIMS.idle

var time := 0.0

func _process(delta):
	time += 1
	if Input.is_key_pressed(KEY_RIGHT):
		current_anim = ANIMS.running
	else:
		current_anim = ANIMS.idle
	match current_anim:
		ANIMS.idle:
			FrontLeg.go_to = get_parent().global_position + Vector2(-10, 30) - Vector2.UP - position
			BackLeg.go_to = get_parent().global_position + Vector2(10, 30) - Vector2.UP - position
			position.y += (abs(sin(time * 0.05) * 2) - position.y)/2
			if FrontLeg.position.x < 0:
				FrontLeg.position.x = move_toward(FrontLeg.position.x, -4, 2)
				BackLeg.position.x = move_toward(BackLeg.position.x, 6, 2)
			else:
				FrontLeg.position.x = move_toward(FrontLeg.position.x, 2, 2)
				BackLeg.position.x = move_toward(BackLeg.position.x, -3, 2)
		ANIMS.running:
			var running_slowness := 0.09
			var slowness_running := 1/running_slowness
			var speedness := 5
			var speedness2 := 5
			position.y += (abs(sin(time * running_slowness * 2) * 10) - position.y)/8
			if fmod(time, PI*slowness_running) < PI*(slowness_running/4):
				FrontLeg.position.x = move_toward(FrontLeg.position.x, 0, 2)
				BackLeg.position.x = move_toward(BackLeg.position.x, 0, 2)
				BackLeg.go_to = BackLeg.go_to.move_toward(get_parent().global_position + Vector2(0, 30) - Vector2.UP - position, speedness)
				FrontLeg.go_to = FrontLeg.go_to.move_toward(get_parent().global_position + Vector2(0, 25) - Vector2.UP - position, speedness)
			elif fmod(time, PI*slowness_running) < PI*(slowness_running/4)*2:
				FrontLeg.position.x = move_toward(FrontLeg.position.x, 6, 2)
				BackLeg.position.x = move_toward(BackLeg.position.x, -4, 2)
				BackLeg.go_to = BackLeg.go_to.move_toward(get_parent().global_position + Vector2(-25, 20) - Vector2.UP - position, speedness2)
				FrontLeg.go_to = FrontLeg.go_to.move_toward(get_parent().global_position + Vector2(25, 20) - Vector2.UP - position, speedness2)
			elif fmod(time, PI*slowness_running) < PI*(slowness_running/4)*3:
				FrontLeg.position.x = move_toward(FrontLeg.position.x, 0, 2)
				BackLeg.position.x = move_toward(BackLeg.position.x, 0, 2)
				BackLeg.go_to = BackLeg.go_to.move_toward(get_parent().global_position + Vector2(0, 25) - Vector2.UP - position, speedness)
				FrontLeg.go_to = FrontLeg.go_to.move_toward(get_parent().global_position + Vector2(0, 30) - Vector2.UP - position, speedness)
			else:
				FrontLeg.position.x = move_toward(FrontLeg.position.x, -4, 2)
				BackLeg.position.x = move_toward(BackLeg.position.x, 6, 2)
				BackLeg.go_to = BackLeg.go_to.move_toward(get_parent().global_position + Vector2(25, 20) - Vector2.UP - position, speedness2)
				FrontLeg.go_to = FrontLeg.go_to.move_toward(get_parent().global_position + Vector2(-25, 20) - Vector2.UP - position, speedness2)
			
	FrontFoot.global_position += ((FrontLeg.go_to + position) - FrontFoot.global_position) / 2
	BackFoot.global_position += ((BackLeg.go_to + position) - BackFoot.global_position) / 2
