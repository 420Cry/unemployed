extends Control

@export var game_scene_path: String = "res://scenes/GameScene.tscn"
@onready var main_button_container: VBoxContainer = $MainButtonContainer
@onready var setting_panel: Panel = $SettingPanel

func _ready():
	main_button_container.visible = true
	setting_panel.visible = false
	for button in get_tree().get_nodes_in_group("buttons"):
		if button is ButtonWithSound:
			print("Connecting button:", button.name)
			button.connect("clicked_after_sound", Callable(self, "_on_button_clicked"))

func _on_button_clicked(button: ButtonWithSound):
	match button.name:
		"Start":
			_change_scene_after_sound(game_scene_path)
		"Setting":
			main_button_container.visible = false
			setting_panel.visible = true
		"Quit":
			get_tree().quit()
		"Back":
			main_button_container.visible = true
			setting_panel.visible = false

func _change_scene_after_sound(scene_path: String):
	if scene_path != "":
		var packed_scene = load(scene_path) as PackedScene
		if packed_scene:
			# Free the old scene
			if get_tree().current_scene:
				get_tree().current_scene.queue_free()
			
			# Instantiate the new scene and add it as child of SceneTree root
			var new_scene = packed_scene.instantiate()
			get_tree().root.add_child(new_scene)
			get_tree().current_scene = new_scene
