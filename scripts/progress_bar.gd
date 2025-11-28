extends TextureProgressBar

@export var _min_value = 0.0
@export var _max_value = 100.0
@export var initial_value = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	min_value = _min_value
	max_value = _max_value
	value = initial_value
