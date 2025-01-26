extends RigidBody3D

@onready var speed = 3

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	position.x += speed * delta

func _on_area_3d_body_entered(body):
	if body != self:
		body.on_impact()
		print("arrow signal work! ", body)
		queue_free()
	
func on_impact():
	print("arrow is free!")
	queue_free()
