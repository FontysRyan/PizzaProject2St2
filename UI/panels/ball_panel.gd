extends Panel
var ball = GameController._get_ball(GameController.equipped_ball_index)
var path = ball.get_path()
var text = path.right(-path.rfind("/") - 1).left(-5)
var new_path = str("res://Resources/Ball/" + text + ".tres")
var res = load(new_path)
var sprites : SpriteFrames = res.sprite_frames
var texture : Texture2D = sprites.get_frame_texture("default", 0)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match self.name:
		"BallPanel":
			pass
		"ball_slot1":
			ball = GameController.ball_slot1
			if ball == "":
				sprites = null
				return
			path = ball
			text = path.right(-path.rfind("/") - 1).left(-5)
			new_path = str("res://Resources/Ball/" + text + ".tres")
			res = load(new_path)
			sprites = res.sprite_frames
			texture = sprites.get_frame_texture("default", 0)
		"ball_slot2":
			ball = GameController.ball_slot2
			if ball == "":
				sprites = null
				return
			path = ball
			text = path.right(-path.rfind("/") - 1).left(-5)
			new_path = str("res://Resources/Ball/" + text + ".tres")
			res = load(new_path)
			sprites = res.sprite_frames
			texture = sprites.get_frame_texture("default", 0)
		"ball_slot3":
			ball = GameController.ball_slot3
			if ball == "":
				sprites = null
				return
			path = ball
			text = path.right(-path.rfind("/") - 1).left(-5)
			new_path = str("res://Resources/Ball/" + text + ".tres")
			res = load(new_path)
			sprites = res.sprite_frames
			texture = sprites.get_frame_texture("default", 0)
	$TextureRect.texture = texture


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
