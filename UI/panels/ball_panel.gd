extends Panel
var sprites : SpriteFrames = GameController._get_ball(GameController.equipped_ball_index).sprite_frames

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.sprite_frames = sprites


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
