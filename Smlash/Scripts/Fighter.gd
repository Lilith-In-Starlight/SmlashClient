extends KinematicBody2D

# Client Vars
enum STATES {
	ON_AIR,
	ON_GROUND
}

const MAXYS := 800
const WALKX := 400
const AIRX := 500
const ACC := 50
const AACC := 60
const GRAV := 70
const FRIC := 50
const AFRIC := 70
const JUMP := -800

var health := 0.0
var fighter_id := 0
var speed := Vector2(0, 0)
var air_jumps := 2
var holding_up := false

var state = STATES.ON_AIR

var time_since_attack := 0

# Server Vars
var go_to := Vector2(0, 0)
var go_at := 0

var dead := false


func _physics_process(delta):
	if Server.local_id == fighter_id:
		if position.y > 1000 and not dead:
			dead = true
			Server.rset("deaths", Server.deaths + 1)
		if not Server.deaths == Server.players - 1 and not dead:
			match state:
				STATES.ON_AIR:
					speed.y = move_toward(speed.y, MAXYS, GRAV)
					
					if Input.is_key_pressed(KEY_LEFT):
						speed.x = move_toward(speed.x, -AIRX, AACC)
					elif Input.is_key_pressed(KEY_RIGHT):
						speed.x = move_toward(speed.x, AIRX, AACC)
					else:
						speed.x = move_toward(speed.x, 0, ACC)
					
					if Input.is_key_pressed(KEY_UP) and not holding_up and air_jumps > 0:
						air_jumps -= 1
						speed.y = JUMP
						
					if is_on_floor():
						state = STATES.ON_GROUND
						
				STATES.ON_GROUND:
					air_jumps = 3
					if Input.is_key_pressed(KEY_LEFT):
						speed.x = move_toward(speed.x, -WALKX, ACC)
					elif Input.is_key_pressed(KEY_RIGHT):
						speed.x = move_toward(speed.x, WALKX, ACC)
					else:
						speed.x = move_toward(speed.x, 0, ACC)
						
					if Input.is_key_pressed(KEY_UP) and not holding_up:
						speed.y = JUMP
					
					if not is_on_floor():
						state = STATES.ON_AIR
			
			holding_up = Input.is_key_pressed(KEY_UP)
			

			if health == Server.player_data[fighter_id]["health"]:
				if time_since_attack > 0:
					speed = Vector2.ZERO
					time_since_attack -= 1
				if Input.is_key_pressed(KEY_C) and time_since_attack <= 0:
					time_since_attack = 25
					Server.rpc_id(1, "player_attacks", get_path(), 0.1, 64)
				
				speed = move_and_slide(speed, Vector2.UP)
			else:
				health = Server.player_data[fighter_id]["health"]
			
			Server.rpc_unreliable_id(1, "update_player_server_pos", position, speed.length(), Server.local_id)
	else:
		go_to = Server.player_data[fighter_id]["position"]
		go_at = Server.player_data[fighter_id]["cspeed"]
		if go_at != 0 and position.distance_to(go_to) < 100:
			position = position.move_toward(go_to, go_at*delta)
		else:
			position += (go_to - position) / 2
