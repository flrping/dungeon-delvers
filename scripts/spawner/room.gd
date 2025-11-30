extends Spawner

class_name Room

const ENEMY_COLOR: String = "#f8c53a30"

func _ready() -> void:
	for entity_path in enemy_entity_paths:
		var packed := load(entity_path) as PackedScene
		enemy_entities.append(packed)
		
	for entity_path in ally_entity_paths:
		var packed := load(entity_path) as PackedScene
		ally_entities.append(packed)
		
	if in_control:
		color.set_color(Global.player_color + "30")
	else:
		color.set_color(ENEMY_COLOR)
		
	$Area2D.connect("body_entered", _on_area_2d_body_entered)
	$Area2D.connect("body_exited", _on_area_2d_body_exited)
	Bus.connect("on_enemy_death", _on_enemy_death)
	Bus.connect("on_ally_death", _on_ally_death)
	
	_spawn_captain()

func _on_enemy_death(entity: Entity, _source: Variant) -> void:
	if in_control:
		return
	
	if not tracked_entites.has(entity) and not captain == entity:
		return
		
	tracked_entites.erase(entity)
	
	if entity.job == "captain":
		capture_progress += 25
		is_captain_dead = true
	else:
		capture_progress += 2
		
	if capture_progress >= 100.0 and is_captain_dead:
		in_control = true
		Bus.emit_signal("on_room_capture", self)
		_on_room_capture()
		capture_progress = 0

	var player = get_tree().current_scene.get_node_or_null(Global.player_name + "Player")
	var progress_bar: TextureProgressBar = player.get_node_or_null("PlayerUI/Spawner Life Bar")
	progress_bar.value = 100 - capture_progress

func _on_ally_death(entity: Entity, _source: Variant) -> void:
	if not in_control:
		return
		
	if not tracked_entites.has(entity)  and not captain == entity:
		return
		
	tracked_entites.erase(entity)
	
	if entity.job == "captain":
		capture_progress += 25
		is_captain_dead = true
	else:
		capture_progress += 2
		
	if capture_progress >= 100.0 and is_captain_dead:
		in_control = false
		Bus.emit_signal("on_room_capture", self)
		_on_room_capture()
		capture_progress = 0

func _on_room_capture() -> void:
	for tracked_entity in tracked_entites:
		tracked_entity.queue_free()
	tracked_entites.clear()
	
	if in_control:
		color.set_color(Global.player_color + "30")
	else:
		color.set_color(ENEMY_COLOR)
	
	_spawn_captain()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var player = get_tree().current_scene.get_node_or_null(Global.player_name + "Player")
		var ui = player.get_node_or_null("PlayerUI")
		if ui == null:
			return
			
		var spawner_name: Label = ui.get_node("Room Name Label")
		var progress_bar: TextureProgressBar = ui.get_node("Spawner Life Bar")
		
		spawner_name.text = name
		spawner_name.visible = true
		
		progress_bar.value = 100 - capture_progress
		progress_bar.visible = true
		
		Bus.emit_signal("on_room_enter", self)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var player = get_tree().current_scene.get_node_or_null(Global.player_name + "Player")
		var ui = player.get_node_or_null("PlayerUI")
		if ui == null:
			return
			
		var spawner_name: Label = ui.get_node("Room Name Label")
		var progress_bar: TextureProgressBar = ui.get_node("Spawner Life Bar")
		
		spawner_name.visible = false
		progress_bar.visible = false
		
		Bus.emit_signal("on_room_exit", self)
