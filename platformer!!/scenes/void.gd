extends Area2D

func _ready():
	$Sprite2D/AnimationPlayer.play("flowing")

func _on_body_entered(body):
	if body is player:
		body.handle_void()

