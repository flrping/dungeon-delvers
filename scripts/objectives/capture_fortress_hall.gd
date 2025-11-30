extends Node

func _ready() -> void:
	Global.is_cutscene_playing = true
	var camera: Camera2D = Global.player.get_node("Camera2D")
	var room_1: Node = get_tree().current_scene.get_node("Fortress Headquarters")
	var gate_1: Node = get_tree().current_scene.get_node("Fortress Headquarters Gate 1")
	var gate_2: Node = get_tree().current_scene.get_node("Fortress Headquarters Gate 2")
	var gate_3: Node = get_tree().current_scene.get_node("Fortress Headquarters Gate 3")
	
	gate_1.queue_free()
	gate_2.queue_free()
	gate_3.queue_free()
	await get_tree().process_frame
	
	if room_1 != null:
		var timer: SceneTreeTimer = get_tree().create_timer(3)
		var cutscene_camera: Camera2D = Camera2D.new()
		get_tree().current_scene.add_child(cutscene_camera)
		camera.enabled = false
		cutscene_camera.enabled = true
		
		cutscene_camera.global_position = room_1.global_position
		Global._notify("Fortress Headquarters is open!", 2.0)
		await timer.timeout
		
		cutscene_camera.enabled = false
		cutscene_camera.queue_free()
		camera.enabled = true
		
		Bus.emit_signal("on_objective_complete", Global.current_objective)
	
	Global.is_cutscene_playing = false
	queue_free()
