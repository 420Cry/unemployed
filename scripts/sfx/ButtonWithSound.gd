extends Button
class_name ButtonWithSound

@export var click_sound_path: String = "res://assets/audios/ClickAudio.ogg"
@export var delay_fraction: float = 0.25  # Wait for 25% of sound length before signal

signal clicked_after_sound(button: ButtonWithSound)
 
var player: AudioStreamPlayer

func _ready():
	player = AudioStreamPlayer.new()
	player.stream = load(click_sound_path)
	player.bus = "SFX"
	add_child(player)

	self.pressed.connect(_play_click_sound)

func _play_click_sound():
	if player.playing:
		player.stop()
	player.play()

	# Create short delay timer (only fraction of sound)
	var t = Timer.new()
	t.wait_time = player.stream.get_length() * delay_fraction
	t.one_shot = true
	t.autostart = true
	add_child(t)
	t.timeout.connect(_emit_clicked_after_sound)
	t.timeout.connect(func(): t.queue_free())  # Clean up timer after

func _emit_clicked_after_sound():
	emit_signal("clicked_after_sound", self)
