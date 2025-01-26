extends RigidBody3D

@onready var speed = 3

func _physics_process(delta):
	position.x += speed * delta

func _on_area_3d_body_entered(body):
	if body != self:
		body.on_impact()
		queue_free()
	
func on_impact():
	queue_free()
