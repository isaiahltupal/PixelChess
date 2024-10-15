class_name pawnPromotion
extends Control

signal chosen_promotion(piecetype:Enums.TILEPIECE,evokedPawn:pawn)
var evokedPawn:pawn

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

static func instantiatePawn(evokedPAWN:pawn)->Control:
	var instance = preload("res://Scenes/pawnPromotion.tscn").instantiate()
	instance.evokedPawn = evokedPAWN
	return instance
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_rook_pressed() -> void:
	chosen_promotion.emit(Enums.TILEPIECE.ROOK,self.evokedPawn)


func _on_knight_pressed() -> void:
	chosen_promotion.emit(Enums.TILEPIECE.KNIGHT,self.evokedPawn)


func _on_bishop_pressed() -> void:
	chosen_promotion.emit(Enums.TILEPIECE.BISHOP,self.evokedPawn)


func _on_queen_pressed() -> void:
	chosen_promotion.emit(Enums.TILEPIECE.QUEEN,self.evokedPawn)
