extends Panel
@onready var sprite = $Sprite2D

func update(whole:bool):
	if whole: $Sprite2D/AnimationPlayer.play("full")
	else: $Sprite2D/AnimationPlayer.play("hit")
	
	#if whole: sprite.frame = 0
	#else: sprite.frame = 4
