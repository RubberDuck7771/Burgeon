extends Node2D
@export var level_start_pos: Node2D #write this, then drag the node to the level_1.gd setting to assign as level start pos 
@onready var heartsContainer = $Player/Camera2D2/HeartContainer
@onready var player = $Player

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/level_2.tscn")

func _ready():
	player.healthChanged.connect(heartsContainer.updateHearts)
	heartsContainer.setMaxHearts(player.maxHealth)
	heartsContainer.updateHearts(player.currentHealth)
