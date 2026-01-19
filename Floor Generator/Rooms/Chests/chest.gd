class_name Chest
extends Node2D

enum ChestType {STICK, BALL}
var current_chest_type : ChestType = ChestType.BALL
var gacha = BallGacha
var opened : bool = false


func set_type(new_chest_type: ChestType):
	current_chest_type = new_chest_type
	# Handle scene change here
	match new_chest_type:
		ChestType.STICK:
			gacha = StickGacha
		ChestType.BALL:
			gacha = BallGacha
	gacha._ready()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func touch_chest():
	if !opened:
		opened = true
		var item = null
		item = open_chest()
		Communication.OpenChest.emit(item)

func open_chest() -> PackedScene:
	return gacha.get_item()
