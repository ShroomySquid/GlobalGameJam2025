extends CharacterBody3D
class_name PlayerCharacter

# anim -> idle, walking, sprint, attacking, blowing
# Special states? -> exhausted, stunned, sprinting
signal blowing

enum Conditions{NONE=0, SPRINTING=1, EXHAUSTED=2, STUNNED=4}

const BLOWING_DECAY : float = 10.0
const SPRINT_DECAY : float = 10.0
const LUNG_REGEN_RATE : float = 10.0
const LUNG_REGEN_RATE_SLOW : float = 9.0
const SHARP_TURN_THRESHOLD = deg_to_rad(140.0)

var player_id : int
var team_id : int

@export var _max_speed := 3.0
@export var _max_sprint_speed := 9.0
@export var _acceleration_factor := 8.0
@export var _sprint_acceleration_factor := 14.0
@export var _deceleration_factor := 16.0
@export var _turn_speed := 50.0

@export var _lung_capacity := 5.0

@export var _blow_power := 10.0

@export var _attack_time := 1.5
@export var _attack_speed := 2.0
@export var _attack_scale := 1.0

@export var impact_audio :  AudioStream
@export var blow_audio : AudioStream

var _conditions : Conditions

var _readied := false
var _device_id : int = -1
var _device_input : DeviceInput
var _camera_basis : Transform3D

var _blow_stream : AudioStreamPlayer

func _ready():
	_conditions = Conditions.NONE
	set_device(_device_id)
	await _device_input.connection_changed
	_camera_basis = get_viewport().get_camera_3d().basis
	_readied = true

func set_device(device: int):
	_device_input = DeviceInput.new(device)
	
func _physics_process(delta):
	if _readied:
		if _device_input.is_action_pressed("sprint"):
			_conditions = _conditions | Conditions.SPRINTING
		elif _conditions & Conditions.SPRINTING:
			_conditions = _conditions ^ Conditions.SPRINTING

		var horizontal_velocity := Vector3(velocity.x, 0, velocity.z)
		var horizontal_dir := horizontal_velocity.normalized()
		var horizontal_speed := horizontal_velocity.length()
		
		var input_dir := _device_input.get_vector(&"move_left", &"move_right", &"move_up", &"move_down")
		var movement_dir := _camera_basis * Vector3(input_dir.x, 0.0, input_dir.y)
		movement_dir.y = 0.0
		movement_dir = movement_dir.normalized()
		
		var sharp_turn := horizontal_speed > 0.1 and \
			acos(movement_dir.dot(horizontal_dir)) > SHARP_TURN_THRESHOLD
				
		# TODO: Do we handle sharp turns in a special way?
		if movement_dir.length() > 0.1 and not sharp_turn:
			if horizontal_speed > 0.001:
				horizontal_dir = adjust_facing(
					horizontal_dir,
					movement_dir,
					delta,
					1.0 / horizontal_speed * _turn_speed,
					Vector3.UP
				)
			else:
				horizontal_dir = movement_dir
			
			var current_max_speed = _max_speed
			var current_acceleration = _acceleration_factor
			if _conditions & Conditions.SPRINTING:
				current_max_speed = _max_sprint_speed
				current_acceleration = _sprint_acceleration_factor
				
			if horizontal_speed < current_max_speed:
				horizontal_speed += current_acceleration * delta
			elif horizontal_speed > current_max_speed:
				horizontal_speed -= _deceleration_factor * delta
		else:
			horizontal_speed -= _deceleration_factor * delta
			if horizontal_speed < 0:
				horizontal_speed = 0
				
		var mesh_xform := ($CharacterModelRoot as Node3D).get_transform()
		var facing_mesh := -mesh_xform.basis[0].normalized()
		facing_mesh = (facing_mesh - Vector3.UP * facing_mesh.dot(Vector3.UP)).normalized()

		if horizontal_speed > 0:
			facing_mesh = adjust_facing(
				facing_mesh,
				movement_dir,
				delta,
				1.0 / horizontal_speed * _turn_speed,
				Vector3.UP
			)
		var m3 := Basis(
			-facing_mesh,
			Vector3.UP,
			-facing_mesh.cross(Vector3.UP).normalized()
		)

		$CharacterModelRoot.set_transform(Transform3D(m3, mesh_xform.origin))
				
		velocity = horizontal_speed * horizontal_dir
		var velocity_magnitude = velocity.length()
		if velocity_magnitude > 3.5:
			set_to_running()
		elif velocity_magnitude > 1.0:
			set_to_walking()
		else:
			set_to_idle()
		move_and_slide()
		
		if(_device_input.is_action_pressed("blow") and _lung_capacity > 0.0):
			if _blow_stream:
				if !_blow_stream.playing:
					_blow_stream = SoundManager.play_sound(blow_audio)
			else:
				_blow_stream = SoundManager.play_sound(blow_audio)
			blowing.emit(global_position, team_id)
			_lung_capacity -= BLOWING_DECAY
			if _lung_capacity < 0:
				_lung_capacity = 0

## Adjust facing is taken from the Godot Project Platformer Demo
## https://github.com/godotengine/godot-demo-projects
func adjust_facing(facing: Vector3, target: Vector3, step: float, adjust_rate: float, \
		current_gn: Vector3) -> Vector3:
	var normal := target
	var t := normal.cross(current_gn).normalized()

	var x := normal.dot(facing)
	var y := t.dot(facing)

	var ang := atan2(y,x)

	if absf(ang) < 0.001:
		return facing

	var s := signf(ang)
	ang = ang * s
	var turn := ang * adjust_rate * step
	var a: float
	if ang < turn:
		a = ang
	else:
		a = turn
	ang = (ang - a) * s

	return (normal * cos(ang) + t * sin(ang)) * facing.length()
	
func set_to_idle():
	$CharacterModelRoot/ImportedModel/AnimationPlayer.play(&"Idle Retarget")
	
func set_to_walking():
	$CharacterModelRoot/ImportedModel/AnimationPlayer.play(&"Walking_Anim Retarget_001")
	
func set_to_running():
	$CharacterModelRoot/ImportedModel/AnimationPlayer.play(&"Running_anim Retarget")

func on_impact():
	SoundManager.play_sound(impact_audio)
	velocity = Vector3.ZERO
