extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D2/AnimationPlayer.play("flowing")
