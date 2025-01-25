extends MeshInstance3D

signal Blow

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_pressed("left"):
		global_position.x -= 0.1
	if Input.is_action_pressed("right"):
		global_position.x += 0.1
	if Input.is_action_pressed("up"):
		global_position.z -= 0.1
	if Input.is_action_pressed("down"):
		global_position.z += 0.1
	if Input.is_action_pressed("LeftClick"):
		Blow.emit(global_position, 1)
