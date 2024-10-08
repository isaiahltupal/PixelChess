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
	
static func createVirtualGame()->Game:
	return Game.new()
	
static func getVirtualPieceFromPiece(currPiece:piece,virtualGame:Game) -> piece:
	var virtualPiece:piece = piece.new()
	var piecetype = currPiece.piecetype
	match piecetype:
		Enums.TILEPIECE.ROOK:
			virtualPiece = rook.new()
			virtualPiece.MapPosition = virtualPiece.MapPosition
		Enums.TILEPIECE.BISHOP:
			virtualPiece = bishop.new()
			virtualPiece.MapPosition = virtualPiece.MapPosition
		Enums.TILEPIECE.PAWN:
			virtualPiece = pawn.new()
			virtualPiece.MapPosition = virtualPiece.MapPosition
		Enums.TILEPIECE.KNIGHT:
			virtualPiece = knight.new()
			virtualPiece.MapPosition = virtualPiece.MapPosition
		Enums.TILEPIECE.QUEEN:
			virtualPiece = queen.new()
			virtualPiece.MapPosition = virtualPiece.MapPosition
		Enums.TILEPIECE.KING:
			virtualPiece = king.new()
			virtualPiece.MapPosition = virtualPiece.MapPosition
			
	virtualPiece.firstMove = currPiece.firstMove
	virtualPiece.team = currPiece.team
	virtualPiece.game = virtualGame
	return virtualPiece

static func isTeamChecked(chosengame:Game,chosenteam:Enums.TILETEAM) -> bool:
	var kingPiece:king = getKing(chosengame,chosenteam)
	var setEnemyValidMoves = getSetAllValidMovesFromTeam(chosengame,enemyOfTeam(chosenteam))
	print(enemyOfTeam(chosenteam),kingPiece.MapPosition,"checkking.....")
	if setEnemyValidMoves.has(kingPiece.MapPosition):
		return true
	return false

static func enemyOfTeam(team:Enums.TILETEAM) -> Enums.TILETEAM:
	if team == Enums.TILETEAM.BLACK:
		return Enums.TILETEAM.WHITE
	return Enums.TILETEAM.BLACK
	
static func getSetAllValidMovesFromTeam(chosengame:Game,chosenteam:Enums.TILETEAM) -> Dictionary:
	var setAllValidMoves = {}
	for position in chosengame.PIECES_ON_BOARD.keys():
		var currPiece:piece = chosengame.PIECES_ON_BOARD[position]
		if currPiece.team == chosenteam:
			var currPieceValidMoves:Array = currPiece.getValidPosiiton()
			for pos in currPieceValidMoves:
				setAllValidMoves[pos] = null
	return setAllValidMoves

static func getKing(chosengame:Game,chosenteam:Enums.TILETEAM)->piece:
	for position in chosengame.PIECES_ON_BOARD.keys():
		var currPiece:piece = chosengame.PIECES_ON_BOARD[position]
		if currPiece.team == chosenteam and currPiece.piecetype == Enums.TILEPIECE.KING:
			return currPiece
	assert(false)
	return null
	
