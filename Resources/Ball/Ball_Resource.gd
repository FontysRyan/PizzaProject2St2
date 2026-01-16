class_name Ball
extends Resource

@export var sprite_frames: SpriteFrames
var texture : Texture2D = null
#editable stats
@export var item_name: String
var level: int = 1
@export var bounciness: float = 1
var current_bounciness: float = 1
@export var damage: float = 20
var current_damage: float = 20
@export var weight: float = 5
@export var size: float = 1
@export var ability: Passive_Ability = null

func _ready() -> void:
	if sprite_frames != null:
		texture = sprite_frames.get_frame_texture("default", 0)

func check_level() -> void:
	match level:
		1:
			pass
		2: 
			current_bounciness = bounciness * 1.5
			current_damage = damage * 1.4
		3:
			current_bounciness = bounciness * 1.7
			current_damage = damage * 1.9
		4:
			current_bounciness = bounciness * 1.9
			current_damage = damage * 2.4
		5:
			current_bounciness = bounciness * 2
			current_damage = damage * 3
		_:
			pass
