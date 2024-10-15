extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func startGame() ->void:
	var packed_game:PackedScene = preload("res://Scenes/game.tscn")
	get_tree().change_scene_to_packed(packed_game)
func _on_startbutton_pressed() -> void:
	startGame()