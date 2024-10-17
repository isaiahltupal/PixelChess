extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_again_button_pressed() -> void:
	var packed_game:PackedScene = load("res://Scenes/game.tscn")
	get_tree().change_scene_to_packed(packed_game)

func _on_quit_button_pressed() -> void:
	var packed_game:PackedScene = load("res://Scenes/main_menu.tscn")
	get_tree().change_scene_to_packed(packed_game)
