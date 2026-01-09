extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_new_button_pressed() -> void:
	GameController.set_phase(GameController.GamePhase.NEW_GAME)


func _on_credits_button_pressed() -> void:
	var ball = BallGacha.get_ball()
	var path = ball.get_path()
	print(path)
