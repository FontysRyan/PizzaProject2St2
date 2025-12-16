extends Node

@export var lifetime : float = 10.0
var damage : float

# Called when the node enters the scene tree for the first time.
func _init() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	lifetime -= delta
	if lifetime <= 0:
		queue_free()

func _on_body_entered(body: Node2D):
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()
