extends Node3D

@onready var is_paused := false

@onready var menu = $CanvasLayer/MenuContainer
@onready var settings = $CanvasLayer/Settings
@onready var bubble1 = %Bubble1
@onready var bubble2 = %Bubble2
@onready var dude = %Dude
@onready var p1_score_label = %P1Score
@onready var p2_score_label = %P2Score
@onready var info_label = %InfoLabel

@onready var p1_score := 0
@onready var p2_score := 0

func _ready():
	menu.hide()
	settings.hide()
	info_label.modulate.a = 0
	await get_tree().create_timer(0.5).timeout
	await reset_game()
	info_label.message("Go!", 1.5)

func _process(_delta):
	if Input.is_action_just_pressed("esc"):
		pause_trigger()

func pause_trigger():
	if (is_paused):
		if not settings.visible:
			menu.visible = !menu.visible
		else:
			settings.visible = false
		is_paused = false
		Engine.time_scale = 1
	else:
		menu.visible = !menu.visible
		Engine.time_scale = 0
		is_paused = true

func _on_pause_btn_pressed():
		pause_trigger()

func _on_resume_btn_pressed():
		pause_trigger()

func _on_setting_btn_pressed():
	menu.visible = !menu.visible
	settings.visible = !settings.visible

func _on_settings_exit_settings():
	menu.visible = !menu.visible
	settings.visible = !settings.visible

func _on_quit_btn_pressed():
	get_tree().quit()

func _on_retry_btn_pressed():
	get_tree().change_scene_to_file("res://Scenes/CoreScenes/Game/game.tscn")

func reset_game():
	bubble1.position = Vector3(3.3, 1.0, 0)
	bubble2.position = Vector3(-3.3, 1.0, 0)
	dude.position = Vector3(6.3, 1.0, 0)
	p1_score_label.text = str(p1_score)
	p2_score_label.text = str(p2_score)
	await info_label.start()
	dude.process_mode = 0

func _on_floor_bubble_exited_area(bubble_id : int):
	dude.process_mode = 4
	if bubble_id == 1:
		p2_score += 1
	else:
		p1_score += 1
	await info_label.message("Out!", 1.5)
	await reset_game()
	await info_label.message("Go!", 1.5)
