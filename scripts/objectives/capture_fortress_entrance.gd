extends Node

func _ready() -> void:
	Global.is_cutscene_playing = true
	var camera: Camera2D = Global.player.get_node("Camera2D")
	var room_1: Node = get_tree().current_scene.get_node("Fortress Entrance West")
	var room_2: Node = get_tree().current_scene.get_node("Fortress Storage")
	var gate_1: Node = get_tree().current_scene.get_node("Fortress Entrance West Gate")
	var gate_2: Node = get_tree().current_scene.get_node("Fortress Storage South Gate")
	
	gate_1.queue_free()
	gate_2.queue_free()
	await get_tree().process_frame
	
	print(room_1)
	print(room_2)
	
	if room_1 != null and room_2 != null:
		var timer: SceneTreeTimer = get_tree().create_timer(3)
		var cutscene_camera: Camera2D = Camera2D.new()
		get_tree().current_scene.add_child(cutscene_camera)
		camera.enabled = false
		cutscene_camera.enabled = true
		
		cutscene_camera.global_position = room_1.global_position
		Global._notify("Fortress Entrance West Gate is open!", 2.0)
		await timer.timeout
		
		timer = get_tree().create_timer(3)
		cutscene_camera.global_position = room_2.global_position
		Global._notify("Fortress Storage South Gate is open!", 2.0)
		await timer.timeout
		
		cutscene_camera.enabled = false
		cutscene_camera.queue_free()
		camera.enabled = true
		
		Bus.emit_signal("on_objective_complete", Global.current_objective)
		
	Global.is_cutscene_playing = false
	queue_free()
