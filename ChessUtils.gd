extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func MapGridToChessNotation(location:Vector2i)->String:
	var file = ""
	var rank = ""
	match location.x:
		0:
			file = "a"
		1:
			file = "b"
		2: 
			file = "c"
		3:
			file = "d"
		4: 
			file = "e"
		5:
			file = "f"
		6: 
			file = "g"
		7:
			file = "h"
	
	match location.y:
		0:
			file = "1"
		1:
			file = "2"
		2: 
			file = "3"
		3:
			file = "4"
		4: 
			file = "5"
		5:
			file = "6"
		6: 
			file = "7"
		7:
			file = "8"
	return rank+file
