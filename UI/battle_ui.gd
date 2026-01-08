extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var stick = GameController._get_stick(GameController.equipped_stick_index).texture
	$HBoxContainer/VBoxContainer/HotBar/StickPanel/TextureRect.texture = stick
	var ball = GameController._get_ball(GameController.equipped_ball_index).texture
	$HBoxContainer/VBoxContainer/HotBar/BallPanel/TextureRect.texture = ball


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass




func _on_continue_button_pressed() -> void:
	GameController.set_game_speed(1)
	$PauseMenu.visible = false
	$PauseMenu/CanvasLayer.visible = false

func _on_exit_button_pressed() -> void:
	GameController.set_phase(GameController.GamePhase.MAIN)




func _on_pause_button_pressed() -> void:
	GameController.set_game_speed(0)
	$PauseMenu.visible = true
	$PauseMenu/CanvasLayer.visible = true
