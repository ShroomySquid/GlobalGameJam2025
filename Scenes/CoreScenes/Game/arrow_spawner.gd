extends Node3D

@onready var arrow_scene = load("res://Scenes/Arrow/arrow_bubble.tscn")
@onready var game = $".."

@export var direction : int

var _attack_delay_timer : Timer

func _ready():
	_attack_delay_timer = Timer.new()
	add_child(_attack_delay_timer)
	_attack_delay_timer.wait_time = 3.0
	_attack_delay_timer.one_shot = true
	
func shoot_arrow():
	if _attack_delay_timer.is_stopped():
		_attack_delay_timer.start()
		var new_arrow = arrow_scene.instantiate()
		get_parent().get_parent().get_parent().add_child(new_arrow)
		new_arrow.global_position = global_position
		if direction == 0:
			new_arrow.linear_velocity = Vector3(0,0,5)
		else:
			new_arrow.linear_velocity = Vector3(0,0,-5)
