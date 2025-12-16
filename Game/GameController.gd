extends Node

enum GamePhase {
	PRE_GAME,
	LOAD_GAME,
	POST_GAME,
	DEBUG,
	TRAVEL,
	COMBAT,
	TREASURE,
	DEATH
}
@export var Main_scene: String = ""
@export var Death_scene: String = ""
@export var build_scene: String = ""
@export var fight_scene: String = ""
var current_phase: GamePhase = GamePhase.PRE_GAME

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("close_game"):
		get_tree().quit()
	pass
