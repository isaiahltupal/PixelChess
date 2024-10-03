extends Node2D
class_name Game
#contains the information about the game

#enum TILEPIECE {
	#NULL,
	#PAWN,
	#ROOK,
	#KNIGHT,
	#BISHOP,
	#QUEEN,
	#KING
	#
#}
#
#enum TILETEAM {
	#BLACK,
	#WHITE,
	#NULL
#} 

@export var GridLength = 8
#@export var GAMETEAMS = {} #dicstionary of location team (key is vector2i)
#@export var GAMEPIECES = {} #dictionary of location of piecetype (key is vector2i)
@export var PIECES_ON_BOARD = {}
@export var PlayerTurn:Enums.TILETEAM 

var ValidScenes = []

var board
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initializeValidTiles()
	test()
	PlayerTurn = Enums.TILETEAM.WHITE
		
func _process(delta: float) -> void:
	pass

#PIECE WAS MOVED , UPDATE GAME
func pieceMoved(PreviousMapPosition:Vector2i,NextMapPosition:Vector2i,PieceEvoked:piece)->void:
	var MoveNotation:String = ""
	#TODO HERE
	#check update, check if a piece was eaten, change player turn
	
	#check if piece existed on the new position
	if self.PIECES_ON_BOARD.has(NextMapPosition):
		self.captureEvent(NextMapPosition)
	
	self.changePlayer()
	self.PIECES_ON_BOARD[NextMapPosition] = self.PIECES_ON_BOARD[PreviousMapPosition]
	self.PIECES_ON_BOARD.erase(PreviousMapPosition)

func addPiece(team:Enums.TILETEAM,piecetype:Enums.TILEPIECE,MapPosition:Vector2i)->void:
	var newPiece:piece
	match piecetype:
		Enums.TILEPIECE.ROOK:
			newPiece = rook.createObject(self,team,piecetype,MapPosition)
			newPiece.MapPosition = MapPosition
			newPiece.position = self.getPositionFromGridLocation(MapPosition)
		Enums.TILEPIECE.BISHOP:
			newPiece = bishop.createObject(self,team,piecetype,MapPosition)
			newPiece.MapPosition = MapPosition
			newPiece.position = self.getPositionFromGridLocation(MapPosition)
	
	newPiece.connect("display_valid_moves",_on_display_valid_moves)
	newPiece.connect("reset_valid_moves",removeValidTilesFromView)
	newPiece.connect("piece_moved",pieceMoved)
	PIECES_ON_BOARD[MapPosition] = newPiece
	self.add_child(newPiece)

func getPositionFromGridLocation(gridLocation:Vector2i)->Vector2:
	return self.get_node("board/TileMapLayer").map_to_local(gridLocation)
	
func getGridLocationFromPosition(globalposition:Vector2)->Vector2i:
		return self.get_node("board/TileMapLayer").local_to_map(globalposition)
			
func MovePieceFromTo(previousPosition:Vector2i, nextPosition) ->void :
	PIECES_ON_BOARD[previousPosition].setPosition(nextPosition)
	PIECES_ON_BOARD[nextPosition] = PIECES_ON_BOARD[previousPosition]

func initializeValidTiles()->void:
	var validPacked: PackedScene = preload("res://Scenes/valid.tscn")
	for i in range(64):
		var newValid = validPacked.instantiate()
		newValid.global_position = Vector2(-1000,4000)
		ValidScenes.append(newValid)
		add_child(newValid)

func removeValidTilesFromView()->void:
	for validTile in ValidScenes:
		validTile.global_position = Vector2(-1000,4000)
		
func test():
	addPiece(Enums.TILETEAM.WHITE,Enums.TILEPIECE.ROOK,Vector2i(3,3))
	addPiece(Enums.TILETEAM.WHITE,Enums.TILEPIECE.BISHOP,Vector2i(2,3))
	addPiece(Enums.TILETEAM.BLACK,Enums.TILEPIECE.BISHOP,Vector2i(0,1))
		
func _on_display_valid_moves(Valid_moves:Array)->void:
	var idx = 0
	for Valid_move in Valid_moves:
		ValidScenes[idx].global_position = getPositionFromGridLocation(Valid_move)
		idx+=1

func changePlayer()->void:
	if self.PlayerTurn == Enums.TILETEAM.WHITE:
		self.PlayerTurn = Enums.TILETEAM.BLACK
	else:
		self.PlayerTurn = Enums.TILETEAM.WHITE

func captureEvent(NextMapPosition:Vector2i)->void:
	self.PIECES_ON_BOARD[NextMapPosition].free()
