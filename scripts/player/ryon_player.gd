extends Player

class_name RyonPlayer

@onready var trident = preload("res://scenes/entity/projectile/ryon_trident.tscn")

var has_spawned = false
var is_recovering = false

func _ready() -> void:
	states = {
		"idle": preload("res://scripts/player/states/player_idle_state.gd").new(),
		"move": preload("res://scripts/player/states/player_move_state.gd").new(),
		"attack": preload("res://scripts/player/states/ryon_attack_state.gd").new()
	}
	
	for _state in states.values():
		_state.player = self
		add_child(_state)
	
	_set_state("idle")

func _process(delta: float) -> void:
	if not state:
		return
		
	_apply_i_frames(delta)
	_check_damage_sources(delta)
	
	state.physics_update(delta)
