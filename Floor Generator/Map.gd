extends Node2D

var generator: MapGenerator = MapGenerator.new()

func _ready() -> void:
	generator.name = "Generator"
	add_child(generator)	

# TESTING
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("TEST_INPUT"):
		generator.generate_floor()
