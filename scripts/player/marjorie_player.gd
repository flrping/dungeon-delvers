extends Player

class_name MarjoriePlayer

@onready var attack_hitbox_up: Area2D  = $AttackUpHitbox
@onready var attack_hitbox_down: Area2D  = $AttackDownHitbox
@onready var attack_hitbox_left: Area2D  = $AttackLeftHitbox
@onready var attack_hitbox_right: Area2D  = $AttackRightHitbox

func _ready() -> void:
	speed = 250.0
	
	states = {
		"idle": preload("res://scripts/player/states/player_idle_state.gd").new(),
		"move": preload("res://scripts/player/states/player_move_state.gd").new(),
		"attack": preload("res://scripts/player/states/marjorie_attack_state.gd").new()
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
	move_and_slide()
