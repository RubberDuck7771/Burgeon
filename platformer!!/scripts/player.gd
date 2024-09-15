class_name player
extends CharacterBody2D

signal healthChanged

@export var SPEED = 300.0
const JUMP_VELOCITY = -425.0
@export var immortality: bool = false : set = set_immortality, get = get_immortality
var platVel = Vector2(0,0)
var immortality_timer: Timer = null
var callImmortality = false
var player_fell = false
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var facing = Vector2.RIGHT
var can_control: bool = true

@onready var currentHealth: int = maxHealth
@export var maxHealth = 3

func _physics_process(delta):
	if callImmortality == true:
		set_temp_immortality(2)
	
	if not can_control: return #if you can't control the player (you died), then this function will return nothing
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	var direction = Input.get_axis("ui_left", "ui_right")
	if direction and is_on_floor: #WALKING AND WALKING ANIMATION
		velocity.x = direction * SPEED
		if direction == 1:
			facing = Vector2.RIGHT
			$AnimationPlayer.play("walk right")
		if direction == -1:
			facing = Vector2.LEFT
			$AnimationPlayer.play("walk left")
	else: #IDLE ANIMATION
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if facing == Vector2.RIGHT:
			$AnimationPlayer.play("idle")
		if facing == Vector2.LEFT:
			$AnimationPlayer.play("idle left")
	#JUMPING AND FALL ANIMATION
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.x = platVel.x
		velocity.y = JUMP_VELOCITY
	if (direction == 1 or direction == 0) and not is_on_floor():
		$AnimationPlayer.play("jump right")
	if direction == -1 and not is_on_floor():
		$AnimationPlayer.play("jump left")
	move_and_slide()
	platVel = get_platform_velocity()

func handle_danger() -> void: #GETTING HURT AND DYING
	print("Player hit!")
	frameFreeze(0.5, 1.0)
	callImmortality = true
	visible = false
	await get_tree().create_timer(0.1).timeout
	visible = true
	await get_tree().create_timer(0.1).timeout
	visible = false
	await get_tree().create_timer(0.1).timeout
	visible = true
	currentHealth = currentHealth - 1
	healthChanged.emit(currentHealth)
	callImmortality = false
	if currentHealth == 0 or player_fell == true:
		await get_tree().create_timer(2.5).timeout
		currentHealth = maxHealth
		player_fell = false
		reset_level()

func handle_void() -> void:
	print("Player fell!")
	player_fell = true
	handle_danger()

func reset_level() -> void:
	get_tree().reload_current_scene()
	visible = true
	can_control = true

func frameFreeze(timeScale, duration):
	can_control = false
	Engine.time_scale = timeScale
	await get_tree().create_timer(duration*timeScale).timeout
	Engine.time_scale = 1.0
	can_control = true

func set_immortality(value: bool):
	immortality = value #turn player immortal for cutscenes/after dmg
func get_immortality() -> bool:
	return immortality #is player immortal, yes or no
func set_temp_immortality(time:float):
	if immortality_timer == null:
		immortality_timer = Timer.new()
		immortality_timer.one_shot = true
		add_child(immortality_timer)
	if immortality_timer.timeout.is_connected(set_immortality):
		immortality_timer.timeout.disconnect(set_immortality)
	immortality_timer.set_wait_time(time)
	immortality_timer.timeout.connect(set_immortality.bind(false))
	immortality = true
	immortality_timer.start()


