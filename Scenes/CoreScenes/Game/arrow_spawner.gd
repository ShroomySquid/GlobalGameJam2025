extends Node3D

@onready var arrow_scene = load("res://Scenes/Arrow/arrow_bubble.tscn")

var _attack_delay_timer : Timer

func _ready():
	_attack_delay_timer = Timer.new()
	add_child(_attack_delay_timer)
	_attack_delay_timer.wait_time = 2.0
	_attack_delay_timer.one_shot = true
	
func shoot_arrow(team_id):
	if _attack_delay_timer.is_stopped():
		_attack_delay_timer.start()
		var new_arrow := arrow_scene.instantiate() as RigidBody3D
		get_parent().get_parent().get_parent().add_child(new_arrow)
		new_arrow.global_position = global_position
		if team_id == 1:
			new_arrow.linear_velocity = Vector3(0,0,5)
		else:
			new_arrow.linear_velocity = Vector3(0,0,-5)
			new_arrow.rotation_degrees.y = 180.0
