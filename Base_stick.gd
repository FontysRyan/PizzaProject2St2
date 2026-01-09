extends Node2D
@export var stick_stats : Stick

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TextureRect.texture = stick_stats.texture


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
