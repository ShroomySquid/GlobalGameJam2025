extends Node3D

@onready var is_paused := false

@onready var menu = $CanvasLayer/MenuContainer
@onready var settings = $CanvasLayer/Settings
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
	add_players()
	ready_new_round()

func pause_trigger():
	pass

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

func add_players():
	spawn_player(-1, team_1_id, stage.player_one_spawn_point.position)
	spawn_player(0, team_2_id, stage.player_two_spawn_point.position)

func ready_new_round():
	get_tree().call_group("bubbles", "queue_free")
	get_tree().call_group("arrows", "pop")
	
	await get_tree().get_frame()
	
	spawn_bubble(team_1_id, stage.team_one_bubble_spawn_point.position)
	spawn_bubble(team_2_id, stage.team_two_bubble_spawn_point.position)
	
	## Connecting new bubbles to existing players
	var players = get_tree().get_nodes_in_group("characters")
	var bubbles = get_tree().get_nodes_in_group("bubbles")
	for player in players:
		for bubble in bubbles:
			if !player.blowing_delta.is_connected(bubble.blown_on_delta):
				player.blowing_delta.connect(bubble.blown_on_delta)

	p1_score_label.text = str(p1_score)
	p2_score_label.text = str(p2_score)
	await info_label.start()

func spawn_bubble(bubble_id : int, start_pos):
	var new_bubble = bubble.instantiate()
	new_bubble.bubble_id = bubble_id
	stage.add_child(new_bubble)
	new_bubble.position = start_pos
	new_bubble.bubble_hit.connect(scored)

func spawn_player(device_id : int, team_id : int, start_pos):
	var new_player = player_character.instantiate()
	new_player._device_id = device_id
	new_player.team_id = team_id
	stage.add_child(new_player)
	new_player.position = start_pos

func scored(bubble_id : int, msg : String):
	get_tree().call_group("arrows", "queue_free")
	var player_group = get_tree().get_nodes_in_group("players")
	#for player_instance in player_group:
	#	player_instance.process_mode = 4
	if bubble_id == 1:
		p2_score += 1
	else:
		p1_score += 1
	await info_label.message(msg, 1.5)
	await ready_new_round()
	#for player_instance in player_group:
	#	player_instance.process_mode = 1
	await info_label.message("Go!", 1.5)
