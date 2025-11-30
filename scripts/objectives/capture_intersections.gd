extends Node

func _ready() -> void:
	Global.is_cutscene_playing = true
	var camera: Camera2D = Global.player.get_node("Camera2D")
	var intersection_east_room: Node = get_tree().current_scene.get_node("Central Intersection East")
	var intersection_west_room: Node = get_tree().current_scene.get_node("Central Intersection West")
	var intersection_east_gate: Node = get_tree().current_scene.get_node("Central Intersection East Gate")
	var intersection_west_gate: Node = get_tree().current_scene.get_node("Central Intersection West Gate")
	
	intersection_east_gate.queue_free()
	intersection_west_gate.queue_free()
	await get_tree().process_frame
	
	if intersection_east_room != null and intersection_west_room != null:
		var timer: SceneTreeTimer = get_tree().create_timer(3)
		var cutscene_camera: Camera2D = Camera2D.new()
		get_tree().current_scene.add_child(cutscene_camera)
		camera.enabled = false
		cutscene_camera.enabled = true
		
		cutscene_camera.global_position = intersection_east_room.global_position
		Global._notify("Intersection East Gate is open!", 2.0)
		await timer.timeout
		
		timer = get_tree().create_timer(3)
		cutscene_camera.global_position = intersection_west_room.global_position
		Global._notify("Intersection West Gate is open!", 2.0)
		await timer.timeout
		
		cutscene_camera.enabled = false
		cutscene_camera.queue_free()
		camera.enabled = true
		
		Bus.emit_signal("on_objective_complete", Global.current_objective)
	
	Global.is_cutscene_playing = false
	queue_free()
