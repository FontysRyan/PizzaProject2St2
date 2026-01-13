extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var stick = GameController._get_stick(GameController.equipped_stick_index)
	var path1 = stick.get_path()
	var text1 = path1.right(-path1.rfind("/") - 1).left(-5)
	var new_path1 = str("res://Resources/Stick/" + text1 + ".tres")
	var res1 = load(new_path1)
	var texture : Texture2D = res1.texture
	$HBoxContainer/VBoxContainer/HotBar/StickPanel/TextureRect.texture = texture
	var ball = GameController._get_ball(GameController.equipped_ball_index)
	var path2 = ball.get_path()
	var text2 = path2.right(-path2.rfind("/") - 1).left(-5)
	var new_path2 = str("res://Resources/Ball/" + text2 + ".tres")
	var res2 = load(new_path2)
	var sprites : SpriteFrames = res2.sprite_frames
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

func _unhandled_input(event):
	if event.is_action_pressed("Inventory"):
		$Inventory.visible = !$Inventory.visible
		$Inventory/CanvasLayer.visible = !$Inventory/CanvasLayer.visible
		if Engine.time_scale == clamp(0.0, 0.0, 10.0):
			GameController.set_game_speed(1)
		elif Engine.time_scale == clamp(1.0, 0.0, 10.0):
			GameController.set_game_speed(0)
