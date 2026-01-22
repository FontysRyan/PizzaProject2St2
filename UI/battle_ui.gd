extends Control

var temp_loot : PackedScene = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var stick = GameController._get_stick(GameController.equipped_stick_index)
	var path1 = stick.get_path()
	var text1 = path1.right(-path1.rfind("/") - 1).left(-5)
	var new_path1 = str("res://Resources/Stick/" + text1 + ".tres")
	var res1 = load(new_path1)
	var texture1 : Texture2D = res1.texture
	$MainUi/Center/HotBar/StickPanel/TextureRect.texture = texture1
	var ball = GameController._get_ball(GameController.equipped_ball_index)
	var path2 = ball.get_path()
	var text2 = path2.right(-path2.rfind("/") - 1).left(-5)
	var new_path2 = str("res://Resources/Ball/" + text2 + ".tres")
	var res2 = load(new_path2)
	var sprites : SpriteFrames = res2.sprite_frames
	var texture2 : Texture2D = sprites.get_frame_texture("default", 0)
	$MainUi/Center/HotBar/BallPanel/TextureRect.texture = texture2
	Communication.OpenChest.connect(_on_open_chest)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !GameController.has_ball:
		$MainUi/Center/HotBar/BallPanel/TextureRect.modulate = Color(0.500, 0.500, 0.500, 1.0)
	elif GameController.has_ball:
		$MainUi/Center/HotBar/BallPanel/TextureRect.modulate = Color(1.0, 1.0, 1.0, 1.0)
	pass
	$MainUi/Center/FloorLabel.text = "Floor: " + str(Stats.current_floor)




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
		$Inventory/CanvasLayer/Panel/VBoxContainer/VBoxContainer/StickInventory/stick_slot1._ready()
		$Inventory/CanvasLayer/Panel/VBoxContainer/VBoxContainer/StickInventory/stick_slot2._ready()
		$Inventory/CanvasLayer/Panel/VBoxContainer/VBoxContainer/StickInventory/stick_slot3._ready()
		$Inventory/CanvasLayer/Panel/VBoxContainer/VBoxContainer/BallInventory/ball_slot1._ready()
		$Inventory/CanvasLayer/Panel/VBoxContainer/VBoxContainer/BallInventory/ball_slot2._ready()
		$Inventory/CanvasLayer/Panel/VBoxContainer/VBoxContainer/BallInventory/ball_slot3._ready()
		$Inventory.visible = !$Inventory.visible
		$Inventory/CanvasLayer.visible = !$Inventory/CanvasLayer.visible
		if Engine.time_scale == clamp(0.0, 0.0, 10.0):
			GameController.set_game_speed(1)
		elif Engine.time_scale == clamp(1.0, 0.0, 10.0):
			GameController.set_game_speed(0)



func _on_open_chest(loot) -> void:
	GameController.set_game_speed(0)
	temp_loot = loot
	var text : String
	var texture : Texture2D = null
	var path = loot.get_path()
	var temp_path = path.left(path.rfind("/"))
	match temp_path:
		"res://Looting/Stick loot":
			$ConfirmLoot/CanvasLayer/Panel/VBoxContainer/VBoxContainer/SwitchSlots/switch_slot1/Label.text = GameController.stick_slot1.right(-GameController.stick_slot1.rfind("/") - 1).left(-5)
			$ConfirmLoot/CanvasLayer/Panel/VBoxContainer/VBoxContainer/SwitchSlots/switch_slot1/TextureRect.texture = GameController._get_stick_texture(0)
			$ConfirmLoot/CanvasLayer/Panel/VBoxContainer/VBoxContainer/SwitchSlots/switch_slot2/Label.text = GameController.stick_slot2.right(-GameController.stick_slot2.rfind("/") - 1).left(-5)
			$ConfirmLoot/CanvasLayer/Panel/VBoxContainer/VBoxContainer/SwitchSlots/switch_slot2/TextureRect.texture = GameController._get_stick_texture(1)
			$ConfirmLoot/CanvasLayer/Panel/VBoxContainer/VBoxContainer/SwitchSlots/switch_slot3/Label.text = GameController.stick_slot3.right(-GameController.stick_slot3.rfind("/") - 1).left(-5)
			$ConfirmLoot/CanvasLayer/Panel/VBoxContainer/VBoxContainer/SwitchSlots/switch_slot3/TextureRect.texture = GameController._get_stick_texture(2)
			var stick = path.right(-path.rfind("/") - 1).left(-5)
			var new_path = str("res://Resources/Stick/" + stick + ".tres")
			var res = load(new_path)
			text = res.item_name
			texture = res.texture
		"res://Looting/Ball loot":
			$ConfirmLoot/CanvasLayer/Panel/VBoxContainer/VBoxContainer/SwitchSlots/switch_slot1/Label.text = GameController.ball_slot1.right(-GameController.ball_slot1.rfind("/") - 1).left(-5)
			$ConfirmLoot/CanvasLayer/Panel/VBoxContainer/VBoxContainer/SwitchSlots/switch_slot1/TextureRect.texture = GameController._get_ball_texture(0)
			$ConfirmLoot/CanvasLayer/Panel/VBoxContainer/VBoxContainer/SwitchSlots/switch_slot2/Label.text = GameController.ball_slot2.right(-GameController.ball_slot2.rfind("/") - 1).left(-5)
			$ConfirmLoot/CanvasLayer/Panel/VBoxContainer/VBoxContainer/SwitchSlots/switch_slot2/TextureRect.texture = GameController._get_ball_texture(1)
			$ConfirmLoot/CanvasLayer/Panel/VBoxContainer/VBoxContainer/SwitchSlots/switch_slot3/Label.text = GameController.ball_slot3.right(-GameController.ball_slot3.rfind("/") - 1).left(-5)
			$ConfirmLoot/CanvasLayer/Panel/VBoxContainer/VBoxContainer/SwitchSlots/switch_slot3/TextureRect.texture = GameController._get_ball_texture(2)
			var ball = path.right(-path.rfind("/") - 1).left(-5)
			var new_path = str("res://Resources/Ball/" + ball + ".tres")
			var res = load(new_path)
			var sprites : SpriteFrames = res.sprite_frames
			text = res.item_name
			texture = sprites.get_frame_texture("default", 0)
	$ConfirmLoot/CanvasLayer/Panel/VBoxContainer/VBoxContainer/LootSlotButton/Label.text = text
	$ConfirmLoot/CanvasLayer/Panel/VBoxContainer/VBoxContainer/LootSlotButton/TextureRect.texture = texture
	$ConfirmLoot.visible = true
	$ConfirmLoot/CanvasLayer.visible = true


func _on_switch_slot_1_pressed() -> void:
	var path = temp_loot.get_path()
	var temp_path = path.left(path.rfind("/"))
	match temp_path:
		"res://Looting/Stick loot":
			GameController.stick_slot1 = path
		"res://Looting/Ball loot":
			GameController.ball_slot1 = path
	$ConfirmLoot.visible = false
	$ConfirmLoot/CanvasLayer.visible = false
	GameController.set_game_speed(1)


func _on_switch_slot_2_pressed() -> void:
	var path = temp_loot.get_path()
	var temp_path = path.left(path.rfind("/"))
	match temp_path:
		"res://Looting/Stick loot":
			GameController.stick_slot2 = path
		"res://Looting/Ball loot":
			GameController.ball_slot2 = path
	$ConfirmLoot.visible = false
	$ConfirmLoot/CanvasLayer.visible = false
	GameController.set_game_speed(1)


func _on_switch_slot_3_pressed() -> void:
	var path = temp_loot.get_path()
	var temp_path = path.left(path.rfind("/"))
	match temp_path:
		"res://Looting/Stick loot":
			GameController.stick_slot3 = path
		"res://Looting/Ball loot":
			GameController.ball_slot3 = path
	$ConfirmLoot.visible = false
	$ConfirmLoot/CanvasLayer.visible = false
	GameController.set_game_speed(1)
