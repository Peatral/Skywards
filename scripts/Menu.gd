extends Control

func _on_StartButton_pressed():
	get_tree().change_scene_to(load("res://scenes/Test.tscn"))
