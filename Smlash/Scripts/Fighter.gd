extends KinematicBody2D

# Client Vars
enum STATES {
	ON_AIR,
	ON_GROUND
}

enum ANIM_STATES {
	GROUND,
	AIR
}

const MAXYS := 800
const WALKX := 500
const AIRX := 600
const ACC := 70
const AACC := 80
const GRAV := 70
const FRIC := 50
const AFRIC := 70
const JUMP := -800

onready var FloorDetector := $FloorDetector
onready var Animations := $Sprite

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

var time_damaged := 0

var stocks := 3
var dead := false

var anim_state = ANIM_STATES.AIR
var time_since_hit := 0.0

func _physics_process(delta):
	$Polygon2D2.visible = (Server.local_id == fighter_id)
	if Server.local_id == fighter_id:
		if Server.local_updated:
			Server.local_updated = false
			position = Server.player_data[Server.local_id]["position"]
			speed = Server.player_data[Server.local_id]["vspeed"]
		if position.y > 1000 and stocks > 0:
			stocks -= 1
			position.y = -70
			position.x = 175 + ((fighter_id-1)*(450/(Server.players-1)))
			Server.rpc_id(1, "update_player_health", Server.local_id, 0.0)
		if stocks <= 0 and not dead:
			dead = true
			Server.rset("deaths", Server.deaths + 1)
		if not Server.deaths == Server.players - 1 and stocks > 0:
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
				if time_damaged < 0:
					if time_since_attack > 0:
						time_since_attack -= 1
					if Input.is_key_pressed(KEY_C) and time_since_attack <= 0:
						time_since_attack = 8
					
					speed = move_and_slide(speed, Vector2.UP)
				else:
					time_damaged -= 1
			else:
				time_since_attack = 0
				time_damaged = 2
				health = Server.player_data[fighter_id]["health"]
			
			
			Server.rpc_unreliable_id(1, "update_player_server_pos", position, speed.length(), Server.local_id)
	else:
		go_to = Server.player_data[fighter_id]["position"]
		go_at = Server.player_data[fighter_id]["cspeed"]
		if go_at != 0 and position.distance_to(go_to) < 100:
			position = position.move_toward(go_to, go_at*delta)
		else:
			position += (go_to - position) / 2
	
	if time_damaged > 0:
		time_since_hit = abs((speed.length() + go_at) / 200)
		print(speed.length())
		
	if time_since_hit > 10:
		time_since_hit = 10
	

	if FloorDetector.is_colliding():
		anim_state = ANIM_STATES.GROUND
	else:
		anim_state = ANIM_STATES.AIR
	
	if time_since_hit < 0:
		match anim_state:
			ANIM_STATES.GROUND:
				if (Server.local_id == fighter_id and speed.length() > 1) or go_at > 1:
					Animations.current_anim = Animations.ANIMS.running
				else:
					Animations.current_anim = Animations.ANIMS.idle
	else:
		time_since_hit -= 1
		if Animations.current_anim != Animations.ANIMS.nothing:
			Animations.current_anim = Animations.ANIMS.nothing
			Animations.last_pos = position
