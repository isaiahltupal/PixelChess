extends piece
class_name pawn

var vulenerableFromEnPassant:bool = false
#var doublePawnMove:bool = false
	
#override this
static func createObject(piecegame:Game,pieceteam:Enums.TILETEAM,tilepiece:Enums.TILEPIECE,MapPostion:Vector2i) -> pawn:
	var my_scene: PackedScene = preload("res://Scenes/pawn.tscn")
	var newPiece = my_scene.instantiate()
	newPiece.game = piecegame
	newPiece.team = pieceteam
	newPiece.piecetype = tilepiece
	newPiece.MapPosition = MapPostion
	if pieceteam == Enums.TILETEAM.BLACK:
		newPiece.spritePATH = "res://Assets/blackpawn.png"
	else:
		newPiece.spritePATH = "res://Assets/whitepawn.png"
	newPiece.updateSprite()
	return newPiece

func _ready() -> void:
	self.connect("piece_moved",checkEnPassantVulnerable)
	self.game.connect("player_has_changed",checkEnPassantVulnerableReset)

#override
func getValidPosiiton()->Array:
	self.ValidGridLocation = [] #set to empty
	self.getPawnValidPosition()
	self.getValidEnPassant()

	return self.ValidGridLocation
	
func getValidEnPassant()->void:
	#FIX THIS LATER NALANG
	var y_delta = 1
	if self.team == Enums.TILETEAM.WHITE:
		y_delta = -1
		
	var left_check = Vector2i(self.MapPosition.x-1,self.MapPosition.y)
	var left_move = Vector2i(self.MapPosition.x-1,self.MapPosition.y+y_delta)
	var right_check = Vector2i(self.MapPosition.x+1,self.MapPosition.y)
	var right_move = Vector2i(self.MapPosition.x+1,self.MapPosition.y+y_delta)
	
	if self.game.PIECES_ON_BOARD.has(left_check):
		var chosen_piece:piece = self.game.PIECES_ON_BOARD[left_check]
		if chosen_piece.piecetype == Enums.TILEPIECE.PAWN and self.isEnemy(chosen_piece.team):
			var chosen_pawn:pawn = chosen_piece
			if chosen_pawn.vulenerableFromEnPassant and self.isValidTile(left_move):
				self.ValidGridLocation.append(left_move)
				
	if self.game.PIECES_ON_BOARD.has(right_check):
		var chosen_piece:piece = self.game.PIECES_ON_BOARD[right_check]
		if chosen_piece.piecetype == Enums.TILEPIECE.PAWN and self.isEnemy(chosen_piece.team):
			var chosen_pawn:pawn = chosen_piece
			if chosen_pawn.vulenerableFromEnPassant and self.isValidTile(right_move):
				self.ValidGridLocation.append(right_move)
	
func checkEnPassantVulnerable(PreviousMapPosition:Vector2i,NextMapPosition:Vector2i,args)->void:
	#pawns are tricky and need extra logic	
	var stepcount = abs(PreviousMapPosition.y-NextMapPosition.y)
	self.vulenerableFromEnPassant = false
	if self.firstMove and stepcount == 2:
		self.vulenerableFromEnPassant = true

func checkEnPassantVulnerableReset(currTeam:Enums.TILETEAM)->void:
	if self.team == currTeam:
		self.vulenerableFromEnPassant = false
		
