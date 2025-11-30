extends Node2D

@onready var spawn_point: Node2D = $Spawn
@onready var meredith_player: PackedScene = load("res://scenes/player/meredith_player.tscn")
@onready var ryon_player: PackedScene = load("res://scenes/player/ryon_player.tscn")

func _ready() -> void:
	Bus.emit_signal("on_game_start")
	
	if Global.player_name.to_lower() == "meredith":
		var player_instance: Node2D = meredith_player.instantiate()
		player_instance.position = spawn_point.global_position
		get_tree().current_scene.add_child(player_instance)
	else:
		var player_instance: Node2D = ryon_player.instantiate()
		player_instance.position = spawn_point.global_position
		get_tree().current_scene.add_child(player_instance)
