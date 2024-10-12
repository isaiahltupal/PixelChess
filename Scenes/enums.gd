extends Node

enum TILEPIECE {
	NULL,
	PAWN,
	ROOK,
	KNIGHT,
	BISHOP,
	QUEEN,
	KING
	
}

enum TILETEAM {
	BLACK,
	WHITE,
	NULL
} 

enum SPECIAL_MOVE{
	NULL,
	ENPASSANT,
	CASTLING
}

enum END_REASON{
	CHECKMATE,
	DRAW
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
