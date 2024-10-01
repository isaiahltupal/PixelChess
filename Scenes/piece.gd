extends Node2D
class_name piece 
# Called when the node enters the scene tree for the first time.

signal display_valid_moves(ValidMoves:Array)
signal reset_valid_moves

var team: Enums.TILETEAM
var piecetype: Enums.TILEPIECE
var MapPosition:Vector2i
var game: Game
var ValidGridLoation = []
var spritePATH = "res://Assets/whitepiece.png"
var isOnHover:bool = false

func _ready() -> void:
	pass	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

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

static func createNull(piecegame:Game,mappos:Vector2i) -> piece:
	var my_scene: PackedScene = preload("res://Scenes/piece.tscn")
	var newPiece = my_scene.instantiate()
	newPiece.game = piecegame
	newPiece.team = Enums.TILETEAM.NULL
	newPiece.piecetype = Enums.TILEPIECE.NULL
	newPiece.MapPosition = mappos
	return newPiece


func getValidPosiiton()->Array:
	return []
	
func isEnemy(pieceteam:Enums.TILETEAM)->bool:
	return self.team != pieceteam

func getRookiValidPosition()->void:
	#top
	for y_new in range(self.MapPosition.y,GlobalVariables.LENGTH):
		var NewPosition = Vector2i(self.MapPosition.x,y_new)
		if self.isValidTile(NewPosition):
			self.ValidGridLoation.append(NewPosition)
	

func isValidTile(selectedPosition:Vector2i)->bool:
	if !game.PIECES_ON_BOARD.has(selectedPosition):
		return true
	if !self.isEnemy(self.game.PIECES_ON_BOARD[selectedPosition].team):
		return false
	return true

func _on_area_2d_mouse_entered() -> void:
	if !isEnemy(self.game.PlayerTurn):
		self.display_valid_moves.emit(self.getValidPosiiton())
		self.isOnHover = true

		
func _on_area_2d_mouse_exited() -> void:
	if !isEnemy(self.game.PlayerTurn):
		self.reset_valid_moves.emit()
		self.isOnHover = false

func updateSprite() -> void:
	if self.team != Enums.TILETEAM.NULL:
		var image = Image.new()
		var texture =ImageTexture.new()
		image.load(self.spritePATH)
		texture = ImageTexture.create_from_image(image)
		%Sprite2D.texture = texture
		print(%Sprite2D.position,%Sprite2D.global_position)
		
