extends MeshInstance3D

signal bubble_exited_area

func _on_area_3d_body_entered(body):
	print(body, " has entered.")

func _on_area_3d_body_exited(body):
	bubble_exited_area.emit(body.bubble_id, "Out!")
	print(body, " has exited.")
