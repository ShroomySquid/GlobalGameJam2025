extends Node3D

@onready var arrow_scene = load("res://Scenes/Arrow/arrow_bubble.tscn")
@onready var game = $".."

@export var direction : int

func _ready():
	shoot_arrow()

func shoot_arrow():
	var new_arrow = arrow_scene.instantiate()
	add_child(new_arrow)
	new_arrow.position = position
	if direction > 0:
		new_arrow.speed *= -1
	#new_arrow.arrow_impact.connect(game.on_arrow_hit)
	await get_tree().create_timer(2.0).timeout
	shoot_arrow()
