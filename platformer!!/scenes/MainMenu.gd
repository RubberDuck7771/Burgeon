extends Control

func _on_quit_pressed(): #quits the game
	get_tree().quit()

func _on_controls_pressed(): #control menu
	get_tree().change_scene_to_file("res://scenes/controls.tscn")


func _on_play_pressed(): #sends player to hub
	get_tree().change_scene_to_file("res://scenes/Hub.tscn")


func _on_levels_pressed():  #sends player to levels room
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")
