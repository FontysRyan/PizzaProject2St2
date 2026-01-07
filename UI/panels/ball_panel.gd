extends Panel
var texture : Texture2D = GameController._get_ball(GameController.equipped_ball_index).texture

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TextureRect.texture = texture


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
