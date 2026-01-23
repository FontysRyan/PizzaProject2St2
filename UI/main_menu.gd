extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if GameController.ball_slot1 != "res://Looting/Basic/Basic Ball.tscn" || GameController.ball_slot2 != "" || GameController.ball_slot3 != "" || GameController.stick_slot1 != "res://Looting/Basic/Basic Stick.tscn" || GameController.stick_slot2 != "" || GameController.stick_slot3 != "":
		$VBoxContainer/ContinueButton.disabled = false


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_new_button_pressed() -> void:
	GameController.set_phase(GameController.GamePhase.CUTSCENE)


func _on_credits_button_pressed() -> void:
	var stick = StickGacha.get_stick()
	var path = stick.get_path()
	print(path)


func _on_continue_button_pressed() -> void:
	GameController.set_phase(GameController.GamePhase.LOAD_GAME)
