extends Node2D
class_name DoorObject

var door: PackedScene = preload("res://Floor Generator/Rooms/Doors/Door.tscn")

var is_open: bool = true

var orientation: Vector2 = Vector2.ZERO
var room_spacing: Vector2 = Vector2.ZERO
var room_grid_position: Vector2 = Vector2.ZERO

var animation_translation: Dictionary[Vector2, String] = {
	Vector2.UP:	"Up",
	Vector2.DOWN: "Down",
	Vector2.LEFT: "Left",
	Vector2.RIGHT: "Right",
}

func _init(_orientation: Vector2, _position: Vector2, _grid_position: Vector2, _room_spacing: Vector2 = Vector2.ZERO) -> void:
	var door_object: Node2D = door.instantiate()
	door_object.name = "Door"
	add_child(door_object)

	position = _position
	room_spacing = _room_spacing
	orientation = _orientation
	room_grid_position = _grid_position
	var animation: AnimatedSprite2D = door_object.get_child(0)
	if animation_translation.has(_orientation):
		animation.animation = animation_translation[_orientation]
	else:
		print("Orientation: ", _orientation, " is not valid")
		
func _ready() -> void:
	get_child(0).player_door_interact.connect(move_player_to_room)		
		
func move_player_to_room(_door: DoorObject, player):
	# This is bad practice
	# But I frankly don't care
	# Now to make the player spawn next to the door instead
	# Fuck it bad practice 2: electric boogaloo
	var player_buffer: Vector2 = Vector2(50, 50)
	player.position = self.global_position + ((room_spacing + player_buffer) * orientation)
	get_tree().get_nodes_in_group("Camera")[0].position = (get_viewport_rect().size + room_spacing) * (room_grid_position + orientation) + get_viewport_rect().size/2
	
