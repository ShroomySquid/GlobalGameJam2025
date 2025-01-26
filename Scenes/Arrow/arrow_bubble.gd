extends RigidBody3D

func _on_area_3d_body_entered(body):
	if body != self:
		body.on_impact()
		queue_free()
	
func on_impact():
	queue_free()
