extends AudioStreamPlayer2D

# special bus that is only really used for sounds that play A LOT

var currently_playing: Dictionary[Variant, Variant] = {}

func _queue_sound(sound_name: String, sound_stream: AudioStream, _position: Vector2) -> void:
	if currently_playing.has(sound_name):
		return
	
	var sound_instance: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
	sound_instance.position = _position
	sound_instance.stream = sound_stream
	sound_instance.volume_db = -30.0
	sound_instance.connect("finished", Callable(self, "_on_sound_finished").bind(sound_name, sound_instance))
	add_child(sound_instance)
	sound_instance.play()
	currently_playing[sound_name] = sound_instance
	
func _on_sound_finished(sound_name: String, sound_instance: AudioStreamPlayer2D) -> void:
	if currently_playing.has(sound_name):
		currently_playing.erase(sound_name)
	sound_instance.queue_free()
