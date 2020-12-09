extends Node2D

onready var background = $Background
onready var play_button = $PlayButton
onready var exit_button = $ExitButton

func _ready():
	pass


func _on_PlayButton_pressed():
	get_tree().change_scene("res://Main.tscn")


func _on_ExitButton_pressed():
	get_tree().quit()
