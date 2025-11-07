extends CheckButton
class_name FullscreenToggleButton

@export var toggle_sound_path: String = "res://assets/audios/ToggleAudio.ogg"
@export var delay_fraction: float = 0.25  # Wait for 25% of sound length before action

var player: AudioStreamPlayer

func _ready():
	player = AudioStreamPlayer.new()
	player.stream = load(toggle_sound_path)
	player.bus = "SFX"
	add_child(player)

	self.toggled.connect(_on_toggled_with_sound)

func _on_toggled_with_sound(toggled_on: bool) -> void:
	if player.playing:
		player.stop()
	player.play()

	var t = Timer.new()
	t.wait_time = player.stream.get_length() * delay_fraction
	t.one_shot = true
	t.autostart = true
	add_child(t)
	t.timeout.connect(func():
		_apply_fullscreen_state(toggled_on)
		t.queue_free()
	)

func _apply_fullscreen_state(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
