extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var stick = GameController._get_stick(GameController.equipped_stick_index).texture
	$HBoxContainer/VBoxContainer/HotBar/StickPanel/TextureRect.texture = stick
	var ball = GameController._get_ball(GameController.equipped_ball_index).texture
	$HBoxContainer/VBoxContainer/HotBar/BallPanel/TextureRect.texture = ball


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	pass # Replace with function body.
