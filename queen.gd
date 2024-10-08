extends piece
class_name queen 

#override this
static func createObject(piecegame:Game,pieceteam:Enums.TILETEAM,tilepiece:Enums.TILEPIECE,MapPostion:Vector2i) -> queen:
	var my_scene: PackedScene = preload("res://Scenes/queen.tscn")
	var newPiece = my_scene.instantiate()
	newPiece.game = piecegame
	newPiece.team = pieceteam
	newPiece.piecetype = tilepiece
	newPiece.MapPosition = MapPostion
	if pieceteam == Enums.TILETEAM.BLACK:
		newPiece.spritePATH = "res://Assets/blackqueen.png"
	else:
		newPiece.spritePATH = "res://Assets/whitequeen.png"
	newPiece.updateSprite()
	return newPiece

#override
func getValidPosiiton()->Array:
	self.ValidGridLocation = [] #set to empty
	self.getBishopValidPosition()
	self.getRookiValidPosition()

	return self.ValidGridLocation
