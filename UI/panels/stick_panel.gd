extends Panel
var stick = GameController._get_stick(GameController.equipped_stick_index)
var path = stick.get_path()
var text = path.right(-path.rfind("/") - 1).left(-5)
var new_path = str("res://Resources/Stick/" + text + ".tres")
var res = load(new_path)
var texture : Texture2D = res.texture
var item_name : String = res.item_name

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match self.name:
		"StickPanel":
			stick = GameController._get_stick(GameController.equipped_stick_index)
			path = stick.get_path()
			text = path.right(-path.rfind("/") - 1).left(-5)
			new_path = str("res://Resources/Stick/" + text + ".tres")
			res = load(new_path)
			texture = res.texture
			item_name = res.item_name
		"stick_slot1":
			stick = GameController.stick_slot1
			if stick == "":
				texture = null
				return
			path = stick
			text = path.right(-path.rfind("/") - 1).left(-5)
			new_path = str("res://Resources/Stick/" + text + ".tres")
			res = load(new_path)
			texture = res.texture
			item_name = res.item_name
		"stick_slot2":
			stick = GameController.stick_slot2
			if stick == "":
				texture = null
				return
			path = stick
			text = path.right(-path.rfind("/") - 1).left(-5)
			new_path = str("res://Resources/Stick/" + text + ".tres")
			res = load(new_path)
			texture = res.texture
			item_name = res.item_name
		"stick_slot3":
			stick = GameController.stick_slot3
			if stick == "":
				texture = null
				return
			path = stick
			text = path.right(-path.rfind("/") - 1).left(-5)
			new_path = str("res://Resources/Stick/" + text + ".tres")
			res = load(new_path)
			texture = res.texture
			item_name = res.item_name
	$TextureRect.texture = texture
	$Label.text = item_name

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouse:
		if event.button_mask == MouseButton.MOUSE_BUTTON_LEFT:
			match self.name:
				"StickPanel":
					pass
				"stick_slot1":
					if $TextureRect.texture != null:
						GameController.equipped_stick_index = 0
						var main_panel = get_tree().get_root().get_node("Map/Slight_Zoom_Camera_Temp/BattleUi/MainUi/Center/HotBar/StickPanel")
						main_panel._ready()
				"stick_slot2":
					if $TextureRect.texture != null:
						GameController.equipped_stick_index = 1
						var main_panel = get_tree().get_root().get_node("Map/Slight_Zoom_Camera_Temp/BattleUi/MainUi/Center/HotBar/StickPanel")
						main_panel._ready()
				"stick_slot3":
					if $TextureRect.texture != null:
						GameController.equipped_stick_index = 2
						var main_panel = get_tree().get_root().get_node("Map/Slight_Zoom_Camera_Temp/BattleUi/MainUi/Center/HotBar/StickPanel")
						main_panel._ready()
