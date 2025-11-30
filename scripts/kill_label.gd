extends Label

func _ready() -> void:
	Bus.connect("on_enemy_death", _on_enemy_death)

func _on_enemy_death(_entity, source):
	if source.is_in_group("Player"):
		Global.kills += 1
		text = str(Global.kills)
