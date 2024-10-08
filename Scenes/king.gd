extends piece
class_name king 

#override this
static func createObject(piecegame:Game,pieceteam:Enums.TILETEAM,tilepiece:Enums.TILEPIECE,MapPostion:Vector2i) -> king:
	var my_scene: PackedScene = preload("res://Scenes/king.tscn")
	var newPiece = my_scene.instantiate()
	newPiece.game = piecegame
	newPiece.team = pieceteam
	newPiece.piecetype = tilepiece
	newPiece.MapPosition = MapPostion
	if pieceteam == Enums.TILETEAM.BLACK:
		newPiece.spritePATH = "res://Assets/blackking.png"
	else:
		newPiece.spritePATH = "res://Assets/whiteking.png"
	newPiece.updateSprite()
	return newPiece

#override
func getValidPosiiton()->Array:
	self.ValidGridLoation = [] #set to empty
	self.getKingValidPosition()
	return self.ValidGridLoation
