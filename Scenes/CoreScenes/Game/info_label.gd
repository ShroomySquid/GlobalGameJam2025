extends Label

var min_scale = 0.3
var duration = 0.5
var transparency = 0

func message(new_msg : String, animation_dur : float):
	modulate.a = 1
	scale = Vector2(1, 1)
	var tween = get_tree().create_tween()
	text = new_msg
	tween.tween_property(self, "modulate", Color(255, 255, 255, 0), animation_dur).set_trans(Tween.TRANS_QUAD)
	await get_tree().create_timer(animation_dur + 0.1).timeout

func start():
	await message("3", 1.0)
	await message("2", 1.0)
	await message("1", 1.0)
