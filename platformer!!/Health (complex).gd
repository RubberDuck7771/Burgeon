class_name Health
extends Node2D

signal max_health_changed(difference:int)
signal health_changed(difference: int)
signal health_depleted

@export var max_health: int = 3 : set = set_max_health, get = get_max_health
@export var immortality: bool = false : set = set_immortality, get = get_immortality

var immortality_timer: Timer = null

@onready var health: int = max_health : set = set_health, get = get_health


func set_max_health(value:int):
	var clamped_value = 1 if value <= 0 else value #the if statement is for if you accidentally set max health to 0
	if not clamped_value == max_health: 
		var difference = clamped_value - max_health
		max_health = value
		max_health_changed.emit(difference)
	if health > max_health:
		health = max_health
func get_max_health() -> int:
	return max_health
	
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

func set_health(value:int):
	if value < health and immortality:
		return
	var clamped_value = clamp(value,0, max_health)
	if clamped_value != health:
		var difference = clamped_value - health
		health = value
		health_changed.emit(difference)
	if health == 0:
		health_depleted.emit()
func get_health():
	return health
