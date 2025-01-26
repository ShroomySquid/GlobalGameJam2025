extends RigidBody3D

@onready var speed = 3

func _ready():
	pass # Replace with function body.

<<<<<<< HEAD
=======
func _process(_delta):
	pass

>>>>>>> b4da592 (Simplified scoring signal, implemented on_impact function on bubble, character and arrow, made basic arrow generator)
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
