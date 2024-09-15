extends CharacterBody2D

var speed = -70.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var facing_right = false

func _ready():
	$AnimationPlayer.play("walk")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	if (not $RayCast2D.is_colliding() or not $RayCast2D2.is_colliding() or $RayCast2D3.is_colliding() or $RayCast2D4.is_colliding() ) and is_on_floor(): 
		flip() #enemy flips when reaches edge/wall but not when reaches player
	velocity.x = speed
	move_and_slide()

func flip(): #you can either do this or make a flipped animation, in order to flip your sprite
	facing_right = !facing_right
	if facing_right:
		speed = abs(speed)
		$AnimationPlayer.play("walk right")
	else:
		speed = abs(speed) * -1
		$AnimationPlayer.play("walk")
