extends Control

var hearts: Array[Control] = []

@onready var heart = preload("res://scenes/ui/heart.tscn")
@onready var half_heart = preload("res://scenes/ui/half_heart.tscn")

func _ready() -> void:
	for children in get_children():
		children.queue_free()
	
	var player = get_tree().current_scene.get_node_or_null(Global.player_name + "Player")
	if player == null:
		return
	
	var hearts_needed = player.max_health / 10
	for i in range(hearts_needed):
		var copy = heart.instantiate()
		copy.position = Vector2(32 * i, 0)
		add_child(copy)
		hearts.append(copy)
		
	Bus.connect("on_player_damage", _on_player_damage)
	
func _on_player_damage(player: Player) -> void:
	var current_health = player.current_health
	
	if current_health <= 0:
		return
	
	for i in range(hearts.size()):
		hearts[i].queue_free()
		
		var heart_value = min(current_health, 10)
		if heart_value >= 10:
			hearts[i] = heart.instantiate()
		elif heart_value >= 5:
			hearts[i] = half_heart.instantiate()
		else:
			hearts.pop_back()
			current_health -= 10
			continue
			
		hearts[i].position = Vector2(32 * i, 0)
		add_child(hearts[i])
		
		current_health -= 10
