extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().get_root().size_changed.connect(resize)
	resize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func resize() -> void:
	var x:int = get_viewport().size.x
	var y:int = get_viewport().size.y
	var scaleval:float
	var pixel_width:int = %Sprite2D.texture.get_width()
	var pixel_height:int =  %Sprite2D.texture.get_height()
	var	scalevalx = 1.1*x/pixel_width
	var	scalevaly = 1.1*y/pixel_height
	var scalveval
	if scalevalx>scalevaly:
		scaleval= scalevalx
	else:
		scaleval = scalevaly
	self.scale = Vector2(scaleval,scaleval)
	self.offset = Vector2i(int(.9*x/2),int(.9*y/2))
	
