class_name Chest
extends Node2D

enum ChestType {STICK, BALL}
var current_chest_type : ChestType = ChestType.STICK
var gacha = StickGacha

func set_type(new_chest_type: ChestType):
	current_chest_type = new_chest_type
	print("[ChestType] Type changed to: ", current_chest_type)
	# Handle scene change here
	match new_chest_type:
		ChestType.STICK:
			gacha = StickGacha
		ChestType.BALL:
			gacha = BallGacha

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body):
	var item = null
	if body.is_in_group("Player"):
		item = open_chest()
	

func open_chest() -> PackedScene:
	return gacha.get_item()
