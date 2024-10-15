extends Node2D
class_name Game
#contains the information about the game
#IM SO FUCKED MAN I SHOULD HAVE DECOUPLED THE GAME STATE AND THE PRESENTATION LAYER LMAOOO

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



var GridLength = 8
var PIECES_ON_BOARD = {}
var PlayerTurn:Enums.TILETEAM 
signal player_has_changed(team:Enums.TILETEAM)
signal king_is_Checked(team:Enums.TILETEAM)
signal king_is_notChecked(team:Enums.TILETEAM)
signal game_has_ended(team:Enums.TILETEAM,reason:Enums.END_REASON)

var ValidScenes = []
var pawnPromotionScene:Control
var board
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initializeValidTiles()
	#SetUpBoard()
	test()
	PlayerTurn = Enums.TILETEAM.WHITE
		
func _process(delta: float) -> void:
	pass

#######################################################################
# FOR CREATING VIRTUAL GAME STATES THAT WILL NOT REFLECT ON THE I



#PIECE WAS MOVED , UPDATE GAME
func pieceMoved(PreviousMapPosition:Vector2i,NextMapPosition:Vector2i,PieceEvoked:piece)->void:
	var MoveNotation:String = ""
	#TODO HERE
	#check update, check if a piece was eaten, change player turn
	
	#check if piece existed on the new position
	if self.PIECES_ON_BOARD.has(NextMapPosition):
		self.captureEvent(NextMapPosition)
	
	#check if pawn promotion
	if PieceEvoked.piecetype == Enums.TILEPIECE.PAWN:
		var tite = ChessUtils.isPawnPromotion(PieceEvoked)
		if ChessUtils.isPawnPromotion(PieceEvoked):
			self.pawnPromotionScene = pawnPromotion.instantiatePawn(PieceEvoked)
			add_child(self.pawnPromotionScene)
			self.pawnPromotionScene.connect("chosen_promotion",promotePawn)
			return
			#function ends here and gets re-evoked once a pawn is promoted
	
	#check if piece was a pawn and it was an en passant capture		
	self.changePlayer()
	self.PIECES_ON_BOARD[NextMapPosition] = self.PIECES_ON_BOARD[PreviousMapPosition]
	self.PIECES_ON_BOARD.erase(PreviousMapPosition)
		#check if there is a check
	if ChessUtils.isTeamChecked(self,self.PlayerTurn):
		king_is_Checked.emit(self.PlayerTurn)
		if ChessUtils.isTeamCheckMate(self,self.PlayerTurn):
			checkMateEvent()
	else:
		king_is_notChecked.emit(self.PlayerTurn)

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
		Enums.TILEPIECE.PAWN:
			newPiece = pawn.createObject(self,team,piecetype,MapPosition)
			newPiece.MapPosition = MapPosition
			newPiece.position = self.getPositionFromGridLocation(MapPosition)
		Enums.TILEPIECE.KNIGHT:
			newPiece = knight.createObject(self,team,piecetype,MapPosition)
			newPiece.MapPosition = MapPosition
			newPiece.position = self.getPositionFromGridLocation(MapPosition)
		Enums.TILEPIECE.QUEEN:
			newPiece = queen.createObject(self,team,piecetype,MapPosition)
			newPiece.MapPosition = MapPosition
			newPiece.position = self.getPositionFromGridLocation(MapPosition)
		Enums.TILEPIECE.KING:
			newPiece = king.createObject(self,team,piecetype,MapPosition)
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
	
	addPiece(Enums.TILETEAM.WHITE,Enums.TILEPIECE.ROOK,Vector2i(4,6))
	addPiece(Enums.TILETEAM.BLACK,Enums.TILEPIECE.QUEEN,Vector2i(4,1))
	addPiece(Enums.TILETEAM.WHITE,Enums.TILEPIECE.QUEEN,Vector2i(4,3))
	
	#king 
	addPiece(Enums.TILETEAM.WHITE,Enums.TILEPIECE.KING,Vector2i(4,7))
	addPiece(Enums.TILETEAM.BLACK,Enums.TILEPIECE.KING,Vector2i(4,0))
	addPiece(Enums.TILETEAM.BLACK,Enums.TILEPIECE.PAWN,Vector2i(6,6))
#virtual pieces to check other game states when determining if the check is a checkmate

func SetUpBoard()->void:
	for i in range(GlobalVariables.LENGTH):
		addPiece(Enums.TILETEAM.WHITE,Enums.TILEPIECE.PAWN,Vector2i(i,6))
		addPiece(Enums.TILETEAM.BLACK,Enums.TILEPIECE.PAWN,Vector2i(i,1))
	
	for i in [0,7]:
		addPiece(Enums.TILETEAM.WHITE,Enums.TILEPIECE.ROOK,Vector2i(i,7))
		addPiece(Enums.TILETEAM.BLACK,Enums.TILEPIECE.ROOK,Vector2i(i,0))
	
	for i in [1,6]:
		addPiece(Enums.TILETEAM.WHITE,Enums.TILEPIECE.KNIGHT,Vector2i(i,7))
		addPiece(Enums.TILETEAM.BLACK,Enums.TILEPIECE.KNIGHT,Vector2i(i,0))
		
	for i in [2,5]:
		addPiece(Enums.TILETEAM.WHITE,Enums.TILEPIECE.BISHOP,Vector2i(i,7))
		addPiece(Enums.TILETEAM.BLACK,Enums.TILEPIECE.BISHOP,Vector2i(i,0))
	
	#queen
	addPiece(Enums.TILETEAM.WHITE,Enums.TILEPIECE.QUEEN,Vector2i(3,7))
	addPiece(Enums.TILETEAM.BLACK,Enums.TILEPIECE.QUEEN,Vector2i(3,0))
	
	#king 
		#queen
	addPiece(Enums.TILETEAM.WHITE,Enums.TILEPIECE.KING,Vector2i(4,7))
	addPiece(Enums.TILETEAM.BLACK,Enums.TILEPIECE.KING,Vector2i(4,0))
	
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
	
	%Background.changeBackground(self.PlayerTurn)

func captureEvent(NextMapPosition:Vector2i)->void:
	self.PIECES_ON_BOARD[NextMapPosition].free()
	
func checkMateEvent()->void:
	changePlayer()
	game_has_ended.emit(self.PlayerTurn,Enums.END_REASON.CHECKMATE)
	#get_tree().paused = true
	var endscreen = preload("res://Scenes/end_screen.tscn").instantiate()
	endscreen.display(self.PlayerTurn,Enums.END_REASON.CHECKMATE)
	add_child(endscreen)
	print("checkmate")
	
#list of all valid moves of a team
	pass

func promotePawn(tilepiece:Enums.TILEPIECE,evokedPawn:pawn)->void:
	var mapPosition = evokedPawn.MapPosition
	self.PIECES_ON_BOARD.erase(mapPosition)
	addPiece(self.PlayerTurn,tilepiece,mapPosition)
	if ChessUtils.isTeamChecked(self,self.PlayerTurn):
		king_is_Checked.emit(self.PlayerTurn)
		if ChessUtils.isTeamCheckMate(self,self.PlayerTurn):
			checkMateEvent()
	else:
		king_is_notChecked.emit(self.PlayerTurn)
		self.pawnPromotionScene.queue_free()
	
	
	
	
