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
@export var Dungeon_scene: String = ""
var current_phase: GamePhase = GamePhase.PRE_GAME




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("close_game"):
		get_tree().quit()
	pass


func set_phase(new_phase: GamePhase):
	current_phase = new_phase
	print("[GameState] Phase changed to: ", current_phase)
	# Handle scene change here
	match new_phase:
		GamePhase.PRE_GAME:
			set_game_speed(1)
			clear_run_data()
			get_tree().change_scene_to_file(Dungeon_scene)
			get_tree().paused = false
		GamePhase.LOAD_GAME:
			get_tree().change_scene_to_file(Dungeon_scene)
			get_tree().paused = false
		

func clear_run_data():
	inventory.clear()
	Stats.clear_all()

func set_game_speed(scale: float) -> void:
	# Clamp to prevent negative or absurd values
	Engine.time_scale = clamp(scale, 0.0, 10.0)
	print("Game speed set to:", Engine.time_scale)


#inventory
@export var stick_slot1 : Stick = null
@export var stick_slot2 : Stick = null
@export var stick_slot3 : Stick = null
@export var ball_slot1 : Ball = null
@export var ball_slot2 : Ball = null
@export var ball_slot3 : Ball = null
var inventory : Array = [stick_slot1, stick_slot2, stick_slot3, ball_slot1, ball_slot2, ball_slot3]

var equipped_stick_index : int
var equipped_ball_index : int
