extends Control

@onready var player = $AudioStreamPlayer
@onready var image = $TextureRect

var timer := 4.0
var fade_started := false

func _process(delta: float) -> void:
	if timer > 0.0:
		timer -= delta
	
		if timer <= 1.0 and not fade_started:
			fade_started = true
			_start_fade()

		if timer <= 0.0:
			player.stop()
			get_tree().change_scene_to_file("res://scenes/menu/title.tscn")

func _start_fade() -> void:
	var tween := get_tree().create_tween()
	tween.tween_property(image, "modulate:a", 0.0, 1.0)
