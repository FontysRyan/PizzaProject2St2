extends Node2D

var generator: MapGenerator = MapGenerator.new()

func _ready() -> void:
	generator.name = "Generator"
	add_child(generator)
	generator.generate_floor()

# TESTING
func _process(delta: float) -> void:
	pass
