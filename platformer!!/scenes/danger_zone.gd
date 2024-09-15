extends Area2D
#signal for body entering this area

func _on_body_entered(body):
	if body is player:
		body.handle_danger()
