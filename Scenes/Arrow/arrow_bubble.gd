extends RigidBody3D
class_name ArrowBubble

func _on_body_entered(body: Node) -> void:
	pop()

func pop():
	$PoppedBalloonParticles.emitting = true
	$PoppedBalloonParticles.reparent(get_parent())
	call_deferred(&"queue_free")
