extends piece
class_name knight


#override this
static func createObject(piecegame:Game,pieceteam:Enums.TILETEAM,tilepiece:Enums.TILEPIECE,MapPostion:Vector2i) -> knight:
	var my_scene: PackedScene = preload("res://Scenes/knight.tscn")
	var newPiece = my_scene.instantiate()
	newPiece.game = piecegame
	newPiece.team = pieceteam
	newPiece.piecetype = tilepiece
	newPiece.MapPosition = MapPostion
	if pieceteam == Enums.TILETEAM.BLACK:
		newPiece.spritePATH = "res://Assets/blackknight.png"
	else:
		newPiece.spritePATH = "res://Assets/whiteknight.png"
	newPiece.updateSprite()
	return newPiece

#override
func getValidPosiiton()->Array:
	self.ValidGridLocation = [] #set to empty
	self.getKnightValidPosition()

	return self.ValidGridLocation
