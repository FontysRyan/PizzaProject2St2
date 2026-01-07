extends Node

enum GamePhase {
	MAIN,
	NEW_GAME,
	LOAD_GAME,
	POST_GAME,
	DEBUG,
	TRAVEL,
	COMBAT,
	TREASURE,
	DEATH
}
var Main_scene: String = "res://Scenes/Main menu.tscn"
var Death_scene: String = ""
var Dungeon_scene: String = "res://Floor Generator/Map.tscn"
var current_phase: GamePhase = GamePhase.MAIN

#inventory
var stick_slot1 : String
var stick_slot2 : String
var stick_slot3 : String
var equipped_stick_index : int = 0

var ball_slot1 : String
var ball_slot2 : String
var ball_slot3 : String
var equipped_ball_index : int = 0

func _ready() -> void:
	stick_slot1 = "res://Resources/Stick/Debug Stick.tres"
	stick_slot2 = "res://Resources/Stick/Debug Stick.tres"
	stick_slot3 = "res://Resources/Stick/Debug Stick.tres"
	ball_slot1 = "res://Resources/Ball/Debug Ball.tres"
	ball_slot2 = "res://Resources/Ball/Debug Ball.tres"
	ball_slot3 = "res://Resources/Ball/Debug Ball.tres"
	
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_phase(new_phase: GamePhase):
	current_phase = new_phase
	print("[GameState] Phase changed to: ", current_phase)
	# Handle scene change here
	match new_phase:
		GamePhase.MAIN:
			set_game_speed(1)
			get_tree().change_scene_to_file(Main_scene)
			get_tree().paused = false
		GamePhase.NEW_GAME:
			set_game_speed(1)
			clear_run_data()
			get_tree().change_scene_to_file(Dungeon_scene)
			get_tree().paused = false
		GamePhase.LOAD_GAME:
			get_tree().change_scene_to_file(Dungeon_scene)
			get_tree().paused = false
		


func set_game_speed(scale: float) -> void:
	# Clamp to prevent negative or absurd values
	Engine.time_scale = clamp(scale, 0.0, 10.0)
	print("Game speed set to:", Engine.time_scale)

func _get_stick(index : int) -> Stick:
	var stick
	match index:
		0:
			stick = load(stick_slot1)
			stick._ready()
			return stick
		1:
			stick = load(stick_slot2)
			stick._ready()
			return stick
		2:
			stick = load(stick_slot3)
			stick._ready()
			return stick
		_:
			return null

func _get_ball(index : int) -> Ball:
	var ball
	match index:
		0:
			ball = load(ball_slot1)
			return ball
		1:
			ball = load(ball_slot2)
			return ball
		2:
			ball = load(ball_slot3)
			return ball
		_:
			return null




func clear_run_data():
	stick_slot1 = "res://Resources/Stick/Basic Stick.tres"
	stick_slot2 = ""
	stick_slot3 = ""
	ball_slot1 = "res://Resources/Ball/Basic Ball.tres"
	ball_slot2 = ""
	ball_slot3 = ""
	Stats.clear_all()
