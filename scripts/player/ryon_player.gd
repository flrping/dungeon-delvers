extends Player

class_name RyonPlayer

@onready var attack_hitbox_up: Area2D  = $AttackUpHitbox
@onready var attack_hitbox_down: Area2D  = $AttackDownHitbox
@onready var attack_hitbox_left: Area2D  = $AttackLeftHitbox
@onready var attack_hitbox_right: Area2D  = $AttackRightHitbox
@onready var trident = preload("res://scenes/entity/projectile/ryon_trident.tscn")

var has_spawned = false
var is_recovering = false

func _ready() -> void:
	speed = 250.0
	
	states = {
		"idle": preload("res://scripts/player/states/ryon_idle_state.gd").new(),
		"move": preload("res://scripts/player/states/ryon_move_state.gd").new(),
		"light_attack": preload("res://scripts/player/states/ryon_light_attack_state.gd").new(),
		"heavy_attack": preload("res://scripts/player/states/ryon_heavy_attack_state.gd").new(),
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
