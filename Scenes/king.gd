extends piece
class_name king 

var isChecked:bool

func _ready() -> void:
	self.game.connect("king_is_Checked",self.displayChecked)
	self.game.connect("king_is_notChecked",self.hideChecked)

#override this
static func createObject(piecegame:Game,pieceteam:Enums.TILETEAM,tilepiece:Enums.TILEPIECE,MapPostion:Vector2i) -> king:
	var my_scene: PackedScene = preload("res://Scenes/king.tscn")
	var newPiece = my_scene.instantiate()
	newPiece.game = piecegame
	newPiece.team = pieceteam
	newPiece.piecetype = tilepiece
	print(newPiece.piecetype,"this should be 6")
	assert(newPiece.piecetype==6)
	newPiece.MapPosition = MapPostion
	if pieceteam == Enums.TILETEAM.BLACK:
		newPiece.spritePATH = "res://Assets/blackking.png"
	else:
		newPiece.spritePATH = "res://Assets/whiteking.png"
	newPiece.updateSprite()
	return newPiece

#override
func getValidPosiiton()->Array:
	self.ValidGridLocation = [] #set to empty
	self.getKingValidPosition()
	self.getCastlingPosition()
	return self.ValidGridLocation

func displayChecked(team:Enums.TILETEAM)->void:
	if team == self.team:
		%check.visible = true
		self.isChecked = true

func hideChecked(team:Enums.TILETEAM)->void:
	if team == self.team:
		%check.visible = false
		self.isChecked = false
	
func getCastlingPosition()->void:
	#check if there are rooks who havent moved
	print("fuck")
	var left:Vector2i = Vector2i(0,self.MapPosition.y)
	var right:Vector2i = Vector2i(7,self.MapPosition.y)
	
	if !self.hasMoved and !self.isChecked:
		if self.game.PIECES_ON_BOARD.has(left):
			var leftPiece:piece = self.game.PIECES_ON_BOARD[left]
			print("???")
			if leftPiece.team == self.team and leftPiece.piecetype == Enums.TILEPIECE.ROOK and !leftPiece.hasMoved:
				var tilesAreFreeForCheck:bool = true
				for i in range(1,GlobalVariables.LENGTH-self.MapPosition.x):
					var positionToCheck = Vector2i(self.MapPosition.x-i,self.MapPosition.y)
					if self.game.PIECES_ON_BOARD.has(positionToCheck):
						tilesAreFreeForCheck = false
				if tilesAreFreeForCheck:
					var castlePosition:Vector2i = Vector2i(2,self.MapPosition.y)
					self.ValidGridLocation.append(castlePosition)
					
		if self.game.PIECES_ON_BOARD.has(right):
			var rightPiece:piece = self.game.PIECES_ON_BOARD[right]
			if rightPiece.team == self.team and rightPiece.piecetype == Enums.TILEPIECE.ROOK and !rightPiece.hasMoved:
				var tilesAreFreeForCheck:bool = true
				for i in range(self.MapPosition.x+1,7):
					var positionToCheck = Vector2i(i,self.MapPosition.y)
					if self.game.PIECES_ON_BOARD.has(positionToCheck):
						tilesAreFreeForCheck = false
				if tilesAreFreeForCheck:
					var castlePosition:Vector2i = Vector2i(6,self.MapPosition.y)
					self.ValidGridLocation.append(castlePosition)


	
