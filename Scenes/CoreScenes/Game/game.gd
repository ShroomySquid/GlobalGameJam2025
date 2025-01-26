extends Node3D

@onready var is_paused := false

@onready var menu = $CanvasLayer/MenuContainer
@onready var settings = $CanvasLayer/Settings
#@onready var bubble1 = %Bubble1
#@onready var bubble2 = %Bubble2
#@onready var dude = %Dude
@onready var p1_score_label = %P1Score
@onready var p2_score_label = %P2Score
@onready var info_label = %InfoLabel

@onready var p1_score := 0
@onready var p2_score := 0

@export var bubble : PackedScene
@export var player_character : PackedScene # This would have to change if there was character choices

@onready var stage = $"3DLayer/Stage" as TwoTeamStage
const team_1_id := 1
const team_2_id := 2

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
	get_tree().call_group("bubbles", "queue_free")
	get_tree().call_group("characters", "queue_free")
	#var stage = $"3DLayer/Stage" as TwoTeamStage
	
	spawn_bubble(team_1_id, stage.team_one_bubble_spawn_point.position)
	spawn_bubble(team_2_id, stage.team_two_bubble_spawn_point.position)
	
	spawn_player(0, team_1_id, stage.player_one_spawn_point.position)
	spawn_player(1, team_2_id, stage.player_one_spawn_point.position)
	
	p1_score_label.text = str(p1_score)
	p2_score_label.text = str(p2_score)
	await info_label.start()
	#dude.process_mode = 0

func spawn_bubble(bubble_id : int, start_pos):
	var new_bubble = bubble.instantiate()
	new_bubble.bubble_id = bubble_id
	stage.add_child(new_bubble)
	new_bubble.position = start_pos
	new_bubble.bubble_hit.connect(scored)

func spawn_player(device_id : int, team_id : int, start_pos):
	var new_player = player_character.instantiate()
	var bubble_group = get_tree().get_nodes_in_group("bubbles")
	new_player._device_id = device_id
	new_player.team_id = team_id
	stage.add_child(new_player)
	new_player.position = start_pos
	for bubble_instance in bubble_group:
		new_player.blowing.connect(bubble_instance.on_dude_blow)

func scored(bubble_id : int, msg : String):
	get_tree().call_group("arrows", "queue_free")
	#dude.process_mode = 4
	if bubble_id == 1:
		p2_score += 1
	else:
		p1_score += 1
	await info_label.message(msg, 1.5)
	await reset_game()
	await info_label.message("Go!", 1.5)
