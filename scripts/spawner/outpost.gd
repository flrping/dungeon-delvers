extends Spawner

class_name Outpost

const ENEMY_COLOR: String = "#f8c53a30"

func _ready() -> void:
	_init()
	if in_control:
		color.set_color(Global.player_color + "30")
	else:
		color.set_color(ENEMY_COLOR)
		
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
		_on_outpost_capture()
		capture_progress = 0

func _on_ally_death(entity: Entity, _source: Variant) -> void:
	if not in_control:
		return
		
	if not tracked_entites.has(entity)  and not captain == entity:
		return
	
	if entity.job == "captain":
		capture_progress += 25
		is_captain_dead = true
	else:
		capture_progress += 2
		
	if capture_progress >= 100.0 and is_captain_dead:
		in_control = false
		Bus.emit_signal("on_room_capture", self)
		_on_outpost_capture()
		capture_progress = 0

func _on_outpost_capture() -> void:
	for tracked_entity in tracked_entites:
		tracked_entity.queue_free()
	tracked_entites.clear()
	
	if in_control:
		color.set_color(Global.player_color + "30")
	else:
		color.set_color(ENEMY_COLOR)
	
	_spawn_captain()
