extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var stick = GameController._get_stick(GameController.equipped_stick_index).texture
	$HBoxContainer/VBoxContainer/HotBar/StickPanel/TextureRect.texture = stick
	var ball = GameController._get_ball(GameController.equipped_ball_index)
	var path = ball.get_path()
	var text = path.right(-path.rfind("/") - 1).left(-5)
	var new_path = str("res://Resources/Ball/" + text + ".tres")
	var res = load(new_path)
	var sprites : SpriteFrames = res.sprite_frames
	$HBoxContainer/VBoxContainer/HotBar/BallPanel/AnimatedSprite2D.sprite_frames = sprites


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !GameController.has_ball:
		$HBoxContainer/VBoxContainer/HotBar/BallPanel/AnimatedSprite2D.modulate = Color(0.500, 0.500, 0.500, 1.0)
	elif GameController.has_ball:
		$HBoxContainer/VBoxContainer/HotBar/BallPanel/AnimatedSprite2D.modulate = Color(1.0, 1.0, 1.0, 1.0)
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
