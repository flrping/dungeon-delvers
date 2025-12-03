extends Node2D

@onready var label_settings: LabelSettings = load("res://scenes/fonts/pixel_font_settings.tres")
@onready var spawn_point: Node2D = $Spawn
@onready var meredith_player: PackedScene = load("res://scenes/player/meredith_player.tscn")
@onready var ryon_player: PackedScene = load("res://scenes/player/ryon_player.tscn")
@onready var marjorie_player: PackedScene = load("res://scenes/player/marjorie_player.tscn")
@onready var jade_player: PackedScene = load("res://scenes/player/jade_player.tscn")

func _ready() -> void:
	Bus.emit_signal("on_game_start")
	
	var player_instance: Node2D
	if Global.player_name.to_lower() == "meredith":
		player_instance = meredith_player.instantiate()
		player_instance.position = spawn_point.global_position
		get_tree().current_scene.add_child(player_instance)
	elif Global.player_name.to_lower() == "marjorie":
		player_instance = marjorie_player.instantiate()
		player_instance.position = spawn_point.global_position
		get_tree().current_scene.add_child(player_instance)
	elif Global.player_name.to_lower() == "ryon":
		player_instance = ryon_player.instantiate()
		player_instance.position = spawn_point.global_position
		get_tree().current_scene.add_child(player_instance)
	elif Global.player_name.to_lower() == "jade":
		player_instance = jade_player.instantiate()
		player_instance.position = spawn_point.global_position
		get_tree().current_scene.add_child(player_instance)
	else:
		player_instance = meredith_player.instantiate()
		player_instance.position = spawn_point.global_position
		get_tree().current_scene.add_child(player_instance)
		
	Global.player = player_instance
	Global.player_ui = Global.player.get_node("PlayerUI")
	
	label_settings.font_color = Color.html(Global.player_color)
	
	Bus.connect("on_new_objective", _on_objective_start)
	Bus.connect("on_objective_complete", _on_objective_complete)
	Bus.connect("on_room_capture", _on_room_capture)
	
	Global._setup_objective()
	Global._notify(Global.current_objective.prompt, 5.0)

func _on_objective_complete(_objective):
	Global._next_objective()

func _on_objective_start(objective):
	Global._notify(objective.prompt, 5.0)

func _on_room_capture(spawner: Spawner) -> void:
	if Global.current_objective["type"] != "capture":
		return

	if not Global.objective_related_nodes.has(spawner):
		return

	var all_captured := true
	for node in Global.objective_related_nodes:
		var room: Spawner = node as Spawner
		if not room.in_control:
			all_captured = false
			break

	if not all_captured:
		return

	var on_complete_scripts = Global.current_objective["on_complete"]
	for script_path in on_complete_scripts:
		var script = load(script_path)
		if script:
			var obj_instance = script.new()
			get_tree().current_scene.add_child(obj_instance)
