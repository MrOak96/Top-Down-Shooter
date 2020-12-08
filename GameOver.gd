extends Node2D

func _ready():
	pass

func _on_PlayAgainButton_pressed():
	get_tree().change_scene("res://Main.tscn")

func _on_ExitButton_pressed():
	get_tree().quit()
