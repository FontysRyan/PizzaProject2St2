extends Panel
var ball = GameController._get_ball(GameController.equipped_ball_index)
var path = ball.get_path()
var text = path.right(-path.rfind("/") - 1).left(-5)
var new_path = str("res://Resources/Ball/" + text + ".tres")
var res = load(new_path)
var sprites : SpriteFrames = res.sprite_frames

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.sprite_frames = sprites


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
