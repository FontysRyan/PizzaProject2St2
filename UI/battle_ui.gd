extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var stick = GameController._get_stick(GameController.equipped_stick_index)
	var path1 = stick.get_path()
	var text1 = path1.right(-path1.rfind("/") - 1).left(-5)
	var new_path1 = str("res://Resources/Stick/" + text1 + ".tres")
	var res1 = load(new_path1)
	var texture1 : Texture2D = res1.texture
	$HBoxContainer/VBoxContainer/HotBar/StickPanel/TextureRect.texture = texture1
	var ball = GameController._get_ball(GameController.equipped_ball_index)
	var path2 = ball.get_path()
	var text2 = path2.right(-path2.rfind("/") - 1).left(-5)
	var new_path2 = str("res://Resources/Ball/" + text2 + ".tres")
	var res2 = load(new_path2)
	var sprites : SpriteFrames = res2.sprite_frames
	var texture2 : Texture2D = sprites.get_frame_texture("default", 0)
	$HBoxContainer/VBoxContainer/HotBar/BallPanel/TextureRect.texture = texture2
	Communication.OpenChest.connect(_on_open_chest)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !GameController.has_ball:
		$HBoxContainer/VBoxContainer/HotBar/BallPanel/TextureRect.modulate = Color(0.500, 0.500, 0.500, 1.0)
	elif GameController.has_ball:
		$HBoxContainer/VBoxContainer/HotBar/BallPanel/TextureRect.modulate = Color(1.0, 1.0, 1.0, 1.0)
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

func _on_open_chest(loot) -> void:
	GameController.set_game_speed(0)
	var texture : Texture2D = null
	var path = loot.get_path()
	var temp_path = path.left(path.rfind("/"))
	match temp_path:
		"res://Looting/Stick loot":
			$ConfirmLoot/CanvasLayer/Panel/VBoxContainer/VBoxContainer/SwitchSlots/switch_slot1/TextureRect.texture = GameController._get_stick_texture(0)
			$ConfirmLoot/CanvasLayer/Panel/VBoxContainer/VBoxContainer/SwitchSlots/switch_slot2/TextureRect.texture = GameController._get_stick_texture(1)
			$ConfirmLoot/CanvasLayer/Panel/VBoxContainer/VBoxContainer/SwitchSlots/switch_slot3/TextureRect.texture = GameController._get_stick_texture(2)
			var text = path.right(-path.rfind("/") - 1).left(-5)
			var new_path = str("res://Resources/Stick/" + text + ".tres")
			var res = load(new_path)
			texture = res.texture
		"res://Looting/Ball loot":
			var scale = Vector2(0.16, 0.16)
			$ConfirmLoot/CanvasLayer/Panel/VBoxContainer/VBoxContainer/SwitchSlots/switch_slot1/TextureRect.texture = GameController._get_ball_texture(0)
			$ConfirmLoot/CanvasLayer/Panel/VBoxContainer/VBoxContainer/SwitchSlots/switch_slot2/TextureRect.texture = GameController._get_ball_texture(1)
			$ConfirmLoot/CanvasLayer/Panel/VBoxContainer/VBoxContainer/SwitchSlots/switch_slot3/TextureRect.texture = GameController._get_ball_texture(2)
			var text = path.right(-path.rfind("/") - 1).left(-5)
			var new_path = str("res://Resources/Ball/" + text + ".tres")
			var res = load(new_path)
			var sprites : SpriteFrames = res.sprite_frames
			texture = sprites.get_frame_texture("default", 0)
	$ConfirmLoot/CanvasLayer/Panel/VBoxContainer/VBoxContainer/LootSlotButton/TextureRect.texture = texture
	$ConfirmLoot.visible = true
	$ConfirmLoot/CanvasLayer.visible = true


func _on_switch_slot_1_pressed() -> void:
	$ConfirmLoot.visible = false
	$ConfirmLoot/CanvasLayer.visible = false
	GameController.set_game_speed(1)


func _on_switch_slot_2_pressed() -> void:
	$ConfirmLoot.visible = false
	$ConfirmLoot/CanvasLayer.visible = false
	GameController.set_game_speed(1)


func _on_switch_slot_3_pressed() -> void:
	$ConfirmLoot.visible = false
	$ConfirmLoot/CanvasLayer.visible = false
	GameController.set_game_speed(1)
