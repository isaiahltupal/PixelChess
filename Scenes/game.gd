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
			newPiece.position = self.getPositionFromGridLocation(MapPosition)
	newPiece.connect("display_valid_moves",_on_display_valid_moves)
	newPiece.connect("reset_valid_moves",removeValidTilesFromView)
	PIECES_ON_BOARD[MapPosition] = newPiece
	print(newPiece.get_node("Sprite2D").texture)
	self.add_child(newPiece)

func getPositionFromGridLocation(gridLocation:Vector2i)->Vector2:
	return self.get_node("board/TileMapLayer").map_to_local(gridLocation)
			
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
	addPiece(Enums.TILETEAM.WHITE,Enums.TILEPIECE.ROOK,Vector2i(2,3))
	
	
func _on_display_valid_moves(Valid_moves:Array)->void:
	var idx = 0
	for Valid_move in Valid_moves:
		print(getPositionFromGridLocation(Valid_move))
		ValidScenes[idx].global_position = getPositionFromGridLocation(Valid_move)
		idx+=1
