extends AudioStreamPlayer

@onready var level = preload("res://assets/tracks/xia.field - Level.mp3")
@onready var level_more = preload("res://assets/tracks/xia.field - Level_Battle.mp3")
@onready var timer = $Timer

var timestamp = 0.0

func _ready() -> void:
	timer.connect("timeout", _on_timeout)
	Bus.connect("on_room_enter", _on_room_enter)
	Bus.connect("on_room_exit", _on_room_exit)

func _process(delta: float) -> void:
	timestamp += delta
	
func _on_finished() -> void:
	play()
	timestamp = 0.0

func _on_timeout() -> void:
	stop()
	play()
	timestamp = 0.0

func _on_room_enter(room: Room):
	if not room.in_control:
		stream = level_more
		play(timestamp)
	
func _on_room_exit(_room: Room):
	stream = level
	play(timestamp)
