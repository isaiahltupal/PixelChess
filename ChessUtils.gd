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
	
static func getVirtualPieceFromPiece(currPiece:piece) -> piece:
	var virtualPiece:piece
	var piecetype = currPiece.piecetype
	match piecetype:
		Enums.TILEPIECE.ROOK:
			virtualPiece = rook.new()
		Enums.TILEPIECE.BISHOP:
			virtualPiece = bishop.new()
		Enums.TILEPIECE.PAWN:
			virtualPiece = pawn.new()
		Enums.TILEPIECE.KNIGHT:
			virtualPiece = knight.new()
		Enums.TILEPIECE.QUEEN:
			virtualPiece = queen.new()
		Enums.TILEPIECE.KING:
			virtualPiece = king.new()
		_:
			assert(false)
	virtualPiece.piecetype = piecetype
	virtualPiece.firstMove = currPiece.firstMove
	virtualPiece.team = currPiece.team
	virtualPiece.MapPosition = currPiece.MapPosition
	return virtualPiece

static func isTeamChecked(chosengame:Game,chosenteam:Enums.TILETEAM) -> bool:
	var kingPiece:king = getKing(chosengame,chosenteam)
	var setEnemyValidMoves = getSetAllValidMovesFromTeam(chosengame,enemyOfTeam(chosenteam))
	if setEnemyValidMoves.has(kingPiece.MapPosition):
		print("yeah")
		return true
	return false

static func isTeamCheckMate(chosengame:Game,chosenteam:Enums.TILETEAM) -> bool:
	var legalMoves:Array = getAllLegalMovesFromTeam(chosengame,chosenteam)
	if len(legalMoves)==0:
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

static func getAllLegalMovesFromTeam(chosengame:Game,chosenteam:Enums.TILETEAM) -> Array:
	var legal_list = []
	for position in chosengame.PIECES_ON_BOARD.keys():
		var currPiece:piece = chosengame.PIECES_ON_BOARD[position]
		if currPiece.team == chosenteam:
			var currPieceValidMoves:Array = currPiece.getLegalMoves()
			for pos in currPieceValidMoves:
				legal_list.append(pos)
	return legal_list
	
static func cloneGame(chosengame:Game)->Game:
	var newGame:Game = createVirtualGame()
	for position in chosengame.PIECES_ON_BOARD.keys():
		var currPiece:piece = chosengame.PIECES_ON_BOARD[position]
		var newPiece:piece = getVirtualPieceFromPiece(currPiece)
		newPiece.game = newGame
		newGame.PIECES_ON_BOARD[position] = newPiece
	return newGame
		
	
static func movePieceInGame(chosengame:Game,chosenPiece:piece,newPosition:Vector2i) -> Game:
	#TODO!!!!!
	#have a movePiecehandler for enpassant and castling
	var PreviousMapPosition:Vector2i = chosenPiece.MapPosition
	chosenPiece.MapPosition = newPosition
	chosengame.PIECES_ON_BOARD[newPosition] = chosenPiece
	chosengame.PIECES_ON_BOARD.erase(PreviousMapPosition)
	return chosengame

static func getKing(chosengame:Game,chosenteam:Enums.TILETEAM)->piece:
	for position in chosengame.PIECES_ON_BOARD.keys():
		var currPiece:piece = chosengame.PIECES_ON_BOARD[position]
		if currPiece.team == chosenteam and currPiece.piecetype == Enums.TILEPIECE.KING:
			return currPiece
	assert(false)
	return null

static func isPawnPromotion(evokedPawn:pawn,game:Game)->bool:
	if evokedPawn.team == Enums.TILETEAM.BLACK and evokedPawn.MapPosition.y == 7:
		return true
	elif evokedPawn.team == Enums.TILETEAM.WHITE and evokedPawn.MapPosition.y == 0:
		return true
	else:
		return false
