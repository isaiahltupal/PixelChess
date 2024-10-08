extends Node2D
class_name piece 
# Called when the node enters the scene tree for the first time.

signal display_valid_moves(ValidMoves:Array)
signal reset_valid_moves
signal piece_moved(PreviousMapPosition:Vector2i,NextMapPosition:Vector2i,PieceEvoked:piece)

var team: Enums.TILETEAM
var piecetype: Enums.TILEPIECE
var MapPosition:Vector2i
var game: Game
var ValidGridLocation = []
var spritePATH = "res://Assets/whitepiece.png"
var isOnHover:bool = false
var beingDragged = false
#var vulenerableFromEnPassant = false
var hasMoved = false
var firstMove = false
#var doublePawnMove = false

func _ready() -> void:
	pass	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if beingDragged:
		self.global_position = get_global_mouse_position()	
	
	if self.game.PlayerTurn == self.team:
	#start dragging
		if Input.is_action_pressed("leftMouseClick") and self.pieceCanBeDragged():
			setBeingDragged()
			self.set_scale(Vector2(0.8,0.8))
		
		#release piece
		if Input.is_action_just_released("leftMouseClick") and beingDragged:
			if self.releasedOnValidTile():
				var previousMapPosition = self.MapPosition
				self.MapPosition = self.game.getGridLocationFromPosition(self.global_position)
				self.global_position = self.game.getPositionFromGridLocation(self.MapPosition)
				self.piece_moved.emit(previousMapPosition,self.MapPosition,self)
				if self.hasMoved == false:
					self.firstMove = true
				else:
					self.firstMove == false
				self.hasMoved = true
			else: 
				self.global_position = self.game.getPositionFromGridLocation(self.MapPosition)
				
			self.set_scale(Vector2(1,1))
			self.beingDragged = false
			GlobalVariables.canInitiateDragPiece = true
			self.reset_valid_moves.emit()
			

func _on_area_2d_mouse_entered() -> void:
	print(self.game.PlayerTurn)
	if !isEnemy(self.game.PlayerTurn):
		self.display_valid_moves.emit(self.getLegalMoves())
		self.isOnHover = true

func _on_area_2d_mouse_exited() -> void:
	if !isEnemy(self.game.PlayerTurn):
		self.reset_valid_moves.emit()
		self.isOnHover = false

	
#override this
static func createObject(parentgame:Game,objectteam:Enums.TILETEAM,tilepiece:Enums.TILEPIECE,mapPosition:Vector2i) -> piece:
	var my_scene: PackedScene = preload("res://Scenes/piece.tscn")
	var newPiece = my_scene.instantiate()
	newPiece.game = parentgame
	newPiece.team = objectteam
	newPiece.piecetype = tilepiece
	newPiece.MapPosition = mapPosition
	#override
	return newPiece

func getValidPosiiton()->Array:
	return []


func isEnemy(pieceteam:Enums.TILETEAM)->bool:
	return self.team != pieceteam

func getRookiValidPosition()->void:
	#bottom
	for y_new in range(self.MapPosition.y+1,GlobalVariables.LENGTH):
		var NewPosition = Vector2i(self.MapPosition.x,y_new)
		if self.isValidTile(NewPosition):
			self.ValidGridLocation.append(NewPosition)
			if self.game.PIECES_ON_BOARD.has(NewPosition):
				break
		else:
			break
			
	#top
	for y_new in range(1,self.MapPosition.y+1):
		var NewPosition = Vector2i(self.MapPosition.x,self.MapPosition.y-y_new)
		if self.isValidTile(NewPosition):
			self.ValidGridLocation.append(NewPosition)
			if self.game.PIECES_ON_BOARD.has(NewPosition):
				break
		else:
			break

	#right
	for x_new in range(self.MapPosition.x+1,GlobalVariables.LENGTH):
		var NewPosition = Vector2i(x_new,self.MapPosition.y)
		if self.isValidTile(NewPosition):
			self.ValidGridLocation.append(NewPosition)
			if self.game.PIECES_ON_BOARD.has(NewPosition):
				break
		else:
			break
	
	#left
	for x_new in range(1,self.MapPosition.x+1):
		var NewPosition = Vector2i(self.MapPosition.x - x_new,self.MapPosition.y)
		if self.isValidTile(NewPosition):
			self.ValidGridLocation.append(NewPosition)
			if self.game.PIECES_ON_BOARD.has(NewPosition):
				break
		else:
			break

func getBishopValidPosition()->void:
	#bottom-right
	for delta in range(1,GlobalVariables.LENGTH):
		var NewPosition = Vector2i(self.MapPosition.x+delta,self.MapPosition.y+delta)
		if self.isValidTile(NewPosition):
			self.ValidGridLocation.append(NewPosition)
			if self.game.PIECES_ON_BOARD.has(NewPosition):
				break
		else:
			break
	
	#bottom-left
	for delta in range(1,GlobalVariables.LENGTH):
		var NewPosition = Vector2i(self.MapPosition.x-delta,self.MapPosition.y+delta)
		if self.isValidTile(NewPosition):
			self.ValidGridLocation.append(NewPosition)
			if self.game.PIECES_ON_BOARD.has(NewPosition):
				break
		else:
			break
	
	#top-left
	for delta in range(1,GlobalVariables.LENGTH):
		var NewPosition = Vector2i(self.MapPosition.x-delta,self.MapPosition.y-delta)
		if self.isValidTile(NewPosition):
			self.ValidGridLocation.append(NewPosition)
			if self.game.PIECES_ON_BOARD.has(NewPosition):
				break
		else:
			break
			
	#top-right
	for delta in range(1,GlobalVariables.LENGTH):
		var NewPosition = Vector2i(self.MapPosition.x+delta,self.MapPosition.y-delta)
		if self.isValidTile(NewPosition):
			self.ValidGridLocation.append(NewPosition)
			if self.game.PIECES_ON_BOARD.has(NewPosition):
				break
		else:
			break

func getKnightValidPosition()->void:
	#just list all 8 of them

	var lu = Vector2i(self.MapPosition.x-2,self.MapPosition.y-1)
	var ul = Vector2i(self.MapPosition.x-1,self.MapPosition.y-2)
	var ru = Vector2i(self.MapPosition.x+2,self.MapPosition.y-1)
	var ur = Vector2i(self.MapPosition.x+1,self.MapPosition.y-2)
	var ld = Vector2i(self.MapPosition.x-2,self.MapPosition.y+1)
	var dl = Vector2i(self.MapPosition.x-1,self.MapPosition.y+2)
	var rd = Vector2i(self.MapPosition.x+2,self.MapPosition.y+2)
	var dr = Vector2i(self.MapPosition.x+1,self.MapPosition.y+1)
	
	var listKnight = [lu,ul,ru,ur,ld,dl,rd,dr]
	for pos in listKnight:
		if self.isValidTile(pos):
			self.ValidGridLocation.append(pos)

func getPawnValidPosition()->void:
	var y_delta = 1
	if self.team == Enums.TILETEAM.WHITE:
		y_delta = -1
	
	var forwardPosition = Vector2i(self.MapPosition.x,self.MapPosition.y + y_delta)
	if self.isValidTile(forwardPosition) and !self.game.PIECES_ON_BOARD.has(forwardPosition):
		self.ValidGridLocation.append(forwardPosition)
	
	var forwardPosition2 = Vector2i(self.MapPosition.x,self.MapPosition.y + 2*y_delta)
	if !self.hasMoved :
		if !self.game.PIECES_ON_BOARD.has(forwardPosition2) and !self.game.PIECES_ON_BOARD.has(forwardPosition):
			self.ValidGridLocation.append(forwardPosition2)
	#sideways
	var sidePosition:Vector2i = Vector2i(self.MapPosition.x-1,self.MapPosition.y+y_delta)
	if self.game.PIECES_ON_BOARD.has(sidePosition) and self.isValidTile(sidePosition):
		self.ValidGridLocation.append(sidePosition)
		
	sidePosition = Vector2i(self.MapPosition.x+1,self.MapPosition.y+y_delta)
	if self.game.PIECES_ON_BOARD.has(sidePosition) and self.isValidTile(sidePosition):
		self.ValidGridLocation.append(sidePosition)

func getKingValidPosition()->void:
	var kingvalidtiles = [
		#perpendicular
		Vector2i(self.MapPosition.x+1,self.MapPosition.y),
		Vector2i(self.MapPosition.x-1,self.MapPosition.y),
		Vector2i(self.MapPosition.x,self.MapPosition.y+1),
		Vector2i(self.MapPosition.x,self.MapPosition.y-1),
		#diagonal
		Vector2i(self.MapPosition.x-1,self.MapPosition.y-1),
		Vector2i(self.MapPosition.x+1,self.MapPosition.y+1),
		Vector2i(self.MapPosition.x-1,self.MapPosition.y+1),
		Vector2i(self.MapPosition.x+1,self.MapPosition.y-1),
	]
	
	for possibleValid in kingvalidtiles:
		if self.isValidTile(possibleValid):
			self.ValidGridLocation.append(possibleValid)

func isValidTile(selectedPosition:Vector2i)->bool:
	if !self.game.PIECES_ON_BOARD.has(selectedPosition) and self.tileIsInBoard(selectedPosition):
		return true
	if self.game.PIECES_ON_BOARD.has(selectedPosition):
		if self.isEnemy(self.game.PIECES_ON_BOARD[selectedPosition].team):
			return true
	return false

func tileIsInBoard(SelectedPosition:Vector2i)->bool:
	if SelectedPosition.x < globalVariables.LENGTH and SelectedPosition.y < globalVariables.LENGTH and SelectedPosition.x >= 0 and SelectedPosition.y >= 0 :
		return true
	return false

func removeCheckableValidTiles()->void:
	var idx = 0
	while idx < len(self.ValidGridLocation):
		var possiblevalid = self.ValidGridLocation[idx]
		var newGame = ChessUtils.cloneGame(self.game)
		var copyofPiece:piece = newGame.PIECES_ON_BOARD[self.MapPosition]
		newGame = ChessUtils.movePieceInGame(newGame,copyofPiece,possiblevalid)
		if ChessUtils.isTeamChecked(newGame,self.team):
			self.ValidGridLocation.remove_at(idx)
			idx-=1
		idx+=1

func updateSprite() -> void:
	if self.team != Enums.TILETEAM.NULL:
		var image = Image.new()
		var texture =ImageTexture.new()
		image.load(self.spritePATH)
		texture = ImageTexture.create_from_image(image)
		%Sprite2D.texture = texture
		
func pieceCanBeDragged() -> bool:
	var mousePos = get_global_mouse_position()
	if self.MapPosition == self.game.getGridLocationFromPosition(mousePos) and GlobalVariables.canInitiateDragPiece:
		return true
	return false

func setBeingDragged()->void:
	self.beingDragged = true
	GlobalVariables.canInitiateDragPiece = false

func releasedOnValidTile() -> bool:
	var dragLocation = self.game.getGridLocationFromPosition(self.global_position)
	if dragLocation in self.getLegalMoves():
		return true
	return false

#moves that doesnt result in a check
func getLegalMoves()->Array:
	self.getValidPosiiton()
	self.removeCheckableValidTiles()
	return self.ValidGridLocation
