extends RigidBody3D
class_name Bubble

const max_blow_str = 20
const max_blow_str_divider = 1.5
const max_distance_squared = 36

@export var bubble_id : int
@export var pop_sound : AudioStream
@export var blow_power_curve : Curve

signal bubble_hit

func blown_on_delta(player_global_pos : Vector3, player_id : int, delta : float):
	if player_id != bubble_id:
		return
	var dist = minf((player_global_pos - global_position).length_squared(),max_distance_squared)
	if dist == max_distance_squared:
		return
	else:
		## Get the sample value on the curve
		var dir = (global_position - player_global_pos)
		dir.y = 0
		dir = dir.normalized()
		var blow_power_distance_factor = blow_power_curve.sample(1 - dist / max_distance_squared)
		apply_central_impulse(dir * (max_blow_str * blow_power_distance_factor) * delta)

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
	SoundManager.play_sound(pop_sound)
	$PopParticles.emitting = true
	$PopParticles.reparent(get_parent())
	call_deferred(&"queue_free")
	# pop the bubble animation

## Technically, this should only be for the arrow cause nothing else
## should trigger it.
func _on_body_entered(body: Node) -> void:
	on_impact()
