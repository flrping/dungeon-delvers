extends Control

@onready var start_button: Button = $StartButton
@onready var credits_button: Button = $CreditsButton
@onready var quit_button: Button = $QuitButton
	
func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/character_select.tscn")

func _on_credits_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/credits.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
