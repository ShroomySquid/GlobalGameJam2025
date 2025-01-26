extends RigidBody3D

const max_blow_str = 6
const max_blow_str_divider = 1.5

@export var bubble_id : int

@onready var pop_sound = %PopStreamPlayer

signal bubble_hit

func on_dude_blow(player_pos : Vector3, player_id : int):
	var blow_dir : Vector2
	var blow_str : float
	var blow_len : float
	var angle_coord : Vector2
	
	if player_id != bubble_id:
		return
	angle_coord = Vector2(player_pos.x - global_position.x, player_pos.z - global_position.z)
	blow_len = pow(pow(angle_coord.x, 2) + pow(angle_coord.y, 2), 1.0/2.0)
	blow_str = (max_blow_str - blow_len) / max_blow_str_divider
	if blow_str > 0: 
		blow_dir = Vector2(angle_coord.x / blow_len, angle_coord.y / blow_len)
		push_bubble(blow_dir, blow_str)

func push_bubble(blow_dir : Vector2, blow_str : float):
	var blow_divider := 100
	while blow_str > 0:
		global_position.x -= (blow_str / blow_divider) * blow_dir.x
		global_position.z -= (blow_str / blow_divider) * blow_dir.y
		blow_str -= blow_str / 4
		#blow_str -= 0.5
		if blow_str < 0.1:
			blow_str = 0

func on_impact():
	bubble_hit.emit(bubble_id, "Pop!")
	pop_sound.play()
	# pop the bubble animation
