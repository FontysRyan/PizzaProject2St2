extends Node2D
class_name DoorObject

var door: PackedScene = preload("res://Floor Generator/Rooms/Doors/Door.tscn")

var animation_translation: Dictionary[Vector2, String] = {
	Vector2.UP:	"Up",
	Vector2.DOWN: "Down",
	Vector2.LEFT: "Left",
	Vector2.RIGHT: "Right",
}

func _init(location: Vector2, screen_size: Vector2 = Vector2(1920,1080)) -> void:
	var door_object: Node2D = door.instantiate()
	door_object.name = "Door"
	add_child(door_object)
	
	var offset: Vector2 = screen_size / 2 * location + screen_size/2
	#print("offset: ", offset)
	position = offset
	var animation: AnimatedSprite2D = door_object.get_child(0)
	if animation_translation.has(location):
		animation.animation = animation_translation[location]
	else:
		print("Position: ", location, " is not valid")
	
