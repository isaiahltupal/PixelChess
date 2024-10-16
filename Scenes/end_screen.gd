class_name EndScreen
extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#self.visible = false
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func display(team:Enums.TILETEAM, reason: Enums.END_REASON)->void:
	self.visible = true
	var my_scene: PackedScene = preload("res://Scenes/end_screen.tscn")
	var newPiece = my_scene.instantiate()
	if team == Enums.TILETEAM.BLACK:
		%Team.text = "BLACK"
	else:
		%Team.text = "WHITE"
		




func _on_play_again_button_pressed() -> void:
	var packed_game:PackedScene = preload("res://Scenes/game.tscn")
	get_tree().change_scene_to_packed(packed_game)



func _on_quit_button_pressed() -> void:
	var packed_game:PackedScene = preload("res://Scenes/main_menu.tscn")
	get_tree().change_scene_to_packed(packed_game)
