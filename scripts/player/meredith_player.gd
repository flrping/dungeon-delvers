extends Player

class_name MeredithPlayer

@onready var attack_hitbox_up: Area2D  = $AttackUpHitbox
@onready var attack_hitbox_down: Area2D  = $AttackDownHitbox
@onready var attack_hitbox_left: Area2D  = $AttackLeftHitbox
@onready var attack_hitbox_right: Area2D  = $AttackRightHitbox

func _ready() -> void:
	speed = 250.0
	
	states = {
		"idle": preload("res://scripts/player/states/meredith_idle_state.gd").new(),
		"move": preload("res://scripts/player/states/meredith_move_state.gd").new(),
		"light_attack": preload("res://scripts/player/states/meredith_light_attack_state.gd").new(),
		"heavy_attack": preload("res://scripts/player/states/meredith_heavy_attack_state.gd").new(),
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
	
func _set_state(state_name) -> void:
	if not states.has(state_name):
		push_warning("State '%s' not found" % state_name)
		return

	if state == states[state_name]:
		return

	if state:
		state.exit(states[state_name])

	var prev: PlayerState = state
	state = states[state_name]
	state.enter(prev)

func _apply_i_frames(delta):
	if i_frame_timer > 0.0:
		i_frame_timer -= delta
		i_frame_timer = max(i_frame_timer, 0.0)
	
func _check_damage_sources(_delta) -> void:
	if i_frame_timer > 0.0:
		return
		
	if Global.is_cutscene_playing:
		return
	
	for source in hurtbox.get_overlapping_areas():
		if source.is_in_group("EnemyDamageSource"):
			if state == states["heavy_attack"]:
				_set_state("idle")
				return

			_take_damage(1.0)
			i_frame_timer = i_frame / 1000.0
			return

func _take_damage(amount: float) -> void:
	if amount >= current_health:
		# die stuff
		pass
	else:
		current_health -= amount
