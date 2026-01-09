extends Panel
var stick = GameController._get_stick(GameController.equipped_stick_index)
var path = stick.get_path()
var text = path.right(-path.rfind("/") - 1).left(-5)
var new_path = str("res://Resources/Stick/" + text + ".tres")
var res = load(new_path)
var texture : Texture2D = res.texture

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match self.name:
		"BallPanel":
			pass
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
	$TextureRect.texture = texture

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
