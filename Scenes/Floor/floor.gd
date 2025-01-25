extends MeshInstance3D

func _on_area_3d_body_entered(body):
	print(body, " has entered.")

func _on_area_3d_body_exited(body):
	print(body, " has exited.")
