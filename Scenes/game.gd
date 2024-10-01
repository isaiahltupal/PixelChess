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

var board
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	test()
	PlayerTurn = Enums.TILETEAM.WHITE
#	
		
func _process(delta: float) -> void:
	pass

func addNull(MapPosition:Vector2i) -> void:
	var newPiece = piece.createNull(self,MapPosition)
	PIECES_ON_BOARD[MapPosition] = newPiece
	#newPiece.global_position = self.get_node("board/TileMapLayer").map_to_local(MapPosition)
	print(newPiece.global_position)
	self.add_child(newPiece)

func addPiece(team:Enums.TILETEAM,piecetype:Enums.TILEPIECE,MapPosition:Vector2i)->void:
	var newPiece:piece
	match piecetype:
		Enums.TILEPIECE.ROOK:
			newPiece = rook.createObject(self,team,piecetype,MapPosition)
			newPiece.MapPosition = MapPosition
			newPiece.position = self.get_node("board/TileMapLayer").map_to_local(MapPosition)
	newPiece.connect("display_valid_moves",_on_display_valid_moves)
	PIECES_ON_BOARD[MapPosition] = newPiece
	
	self.add_child(newPiece)
			
func MovePieceFromTo(previousPosition:Vector2i, nextPosition) ->void :
	PIECES_ON_BOARD[previousPosition].setPosition(nextPosition)
	PIECES_ON_BOARD[nextPosition] = PIECES_ON_BOARD[previousPosition]
	
func test():
	addPiece(Enums.TILETEAM.WHITE,Enums.TILEPIECE.ROOK,Vector2i(3,3))
	
func _on_display_valid_moves(Valid_moves:Array)->void:
	print(Valid_moves)
	print("ten feet")
	pass
