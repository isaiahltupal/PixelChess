extends piece
class_name bishop


#override this
static func createObject(piecegame:Game,pieceteam:Enums.TILETEAM,tilepiece:Enums.TILEPIECE,MapPostion:Vector2i) -> bishop:
	var my_scene: PackedScene = preload("res://Scenes/bishop.tscn")
	var newPiece = my_scene.instantiate()
	newPiece.game = piecegame
	newPiece.team = pieceteam
	newPiece.piecetype = tilepiece
	newPiece.MapPosition = MapPostion
	if pieceteam == Enums.TILETEAM.BLACK:
		newPiece.spritePATH = "res://Assets/blackbishop.png"
	else:
		newPiece.spritePATH = "res://Assets/whitebishop.png"
	newPiece.updateSprite()
	print("why is sprite a null instance",newPiece.get_node("%Sprite2D"))
	return newPiece

#override
func getValidPosiiton()->Array:
	self.ValidGridLoation = [] #set to empty
	self.getBishopValidPosition()
	return self.ValidGridLoation
