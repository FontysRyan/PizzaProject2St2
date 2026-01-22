extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func next_floor():
	Stats.current_floor += 1
	GameController.has_ball = true
	GameController.set_phase(GameController.GamePhase.LOAD_GAME)
