extends VBoxContainer

signal exit_settings

@onready var sfx_id = AudioServer.get_bus_index("SFX")
@onready var music_id = AudioServer.get_bus_index("Music")
@onready var master_id = AudioServer.get_bus_index("Master")
@onready var music_slidder = $MenuContainer/BiggerSoundContainer/SoundContainer/MusicSoundSlider
@onready var master_slidder = $MenuContainer/BiggerSoundContainer/SoundContainer/MasterSoundSlider
@onready var sfx_slidder = $MenuContainer/BiggerSoundContainer/SoundContainer/SFXSoundSlider

func _ready():
	GlobalControl.change_volume(master_id, master_slidder.value)
	GlobalControl.change_volume(music_id, music_slidder.value)
	GlobalControl.change_volume(sfx_id, sfx_slidder.value)
	
func _process(_delta):
	pass

func _on_master_sound_slider_value_changed(value):
	GlobalControl.change_volume(master_id, value)

func _on_music_sound_slider_value_changed(value):
	GlobalControl.change_volume(music_id, value)

func _on_sfx_sound_slider_value_changed(value):
	GlobalControl.change_volume(sfx_id, value)

func _on_main_menu_btn_pressed():
	exit_settings.emit()

func _on_resolution_drop_down_item_selected(index):
	if index == 0:
		DisplayServer.window_set_size(Vector2(1024, 576))
	elif index == 1:
		DisplayServer.window_set_size(Vector2(1024, 640))
	elif index == 2:
		DisplayServer.window_set_size(Vector2(1024, 768))
	elif index == 3:
		DisplayServer.window_set_size(Vector2(1152, 720))
	elif index == 4:
		DisplayServer.window_set_size(Vector2(1280, 720))
	elif index == 5:
		DisplayServer.window_set_size(Vector2(1280, 800))
	elif index == 6:
		DisplayServer.window_set_size(Vector2(1280, 960))
	elif index == 7:
		DisplayServer.window_set_size(Vector2(1366, 768))
	elif index == 8:
		DisplayServer.window_set_size(Vector2(1400, 1050))
	elif index == 9:
		DisplayServer.window_set_size(Vector2(1440, 1080))
	elif index == 10:
		DisplayServer.window_set_size(Vector2(1536, 864))
	elif index == 11:
		DisplayServer.window_set_size(Vector2(1600, 900))
	elif index == 12:
		DisplayServer.window_set_size(Vector2(1680, 720))
	elif index == 13:
		DisplayServer.window_set_size(Vector2(1680, 1050))
	elif index == 14:
		DisplayServer.window_set_size(Vector2(1920, 1080))

func _on_fullscreen_btn_toggled(toggled_on):
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_mute_back_btn_toggled(toggled_on):
	GlobalControl.play_music_background = !toggled_on

func _on_apply_btn_pressed():
	pass # Replace with function body.
