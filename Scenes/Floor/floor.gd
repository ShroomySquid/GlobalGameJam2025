extends Node3D

signal bubble_exited_area

func _on_area_3d_body_exited(body):
	if body.is_in_group("bubbles"):
		bubble_exited_area.emit(body.bubble_id, "Out!")
