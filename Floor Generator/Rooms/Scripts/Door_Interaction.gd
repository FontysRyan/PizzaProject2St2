extends Node2D
class_name DoorInteraction

var player_close: bool = false
var player
signal player_door_interact(door_object: DoorObject)

# MAKE EMIT SIGNALS
# Also update to use player class when added
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player = body
		player_close = true
		
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		player_close = false
		
func _unhandled_input(event):
	if player_close and event.is_action_pressed("interact"):
		player_door_interact.emit(self.get_parent(), player)
