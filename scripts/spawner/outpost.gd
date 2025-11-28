extends Spawner

class_name Outpost

const ENEMY_COLOR: String = "#f1080032"
const ALLY_COLOR: String = "#3d86c785"

func _ready() -> void:
	_init()
	if in_control:
		color.set_color(ALLY_COLOR)
	else:
		color.set_color(ENEMY_COLOR)
		
	Bus.connect("on_enemy_death", _on_enemy_death)
	Bus.connect("on_ally_death", _on_ally_death)

func _on_enemy_death(entity: Entity, _source: Variant) -> void:
	if in_control:
		return
		
	if not tracked_entites.has(entity):
		return
		
	tracked_entites.erase(entity)
	capture_progress += 25
	
	capture_progress += 25
	if capture_progress >= 100.0:
		in_control = true
		Bus.emit_signal("on_room_capture", self)
		_on_outpost_capture()
		capture_progress = 0

func _on_ally_death(entity: Entity, _source: Variant) -> void:
	if not in_control:
		return
		
	if not tracked_entites.has(entity):
		return
		
	capture_progress += 25
	if capture_progress >= 100.0:
		in_control = false
		Bus.emit_signal("on_room_capture", self)
		_on_outpost_capture()
		capture_progress = 0

func _on_outpost_capture() -> void:
	for tracked_entity in tracked_entites:
		tracked_entity.queue_free()
	tracked_entites.clear()
	
	if in_control:
		color.set_color(ALLY_COLOR)
	else:
		color.set_color(ENEMY_COLOR)
