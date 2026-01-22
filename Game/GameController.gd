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
var stick_slot1 : String = "res://Looting/Stick loot/Basic Stick.tscn"
var stick_slot2 : String = ""
var stick_slot3 : String = ""
var equipped_stick_index : int = 0

var ball_slot1 : String = "res://Looting/Ball loot/Basic Ball.tscn"
var ball_slot2 : String = ""
var ball_slot3 : String = ""
var equipped_ball_index : int = 0
var has_ball : bool = true
var boss_killed : bool = false

func _ready() -> void:
	stick_slot1 = "res://Looting/Stick loot/Basic Stick.tscn"
	ball_slot1 = "res://Looting/Ball loot/Basic Ball.tscn"
	
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
			has_ball = true
			set_game_speed(1)
			get_tree().change_scene_to_file(Main_scene)
			get_tree().paused = false
		GamePhase.NEW_GAME:
			set_game_speed(1)
			clear_run_data()
			get_tree().change_scene_to_file(Dungeon_scene)
			get_tree().paused = false
		GamePhase.LOAD_GAME:
			set_game_speed(1)
			get_tree().change_scene_to_file(Dungeon_scene)
			get_tree().paused = false
		GamePhase.DEATH:
			var parent = get_tree().get_root().get_node("Map/Slight_Zoom_Camera_Temp")
			var old_ui = parent.get_node("BattleUi")
			parent.remove_child(old_ui)
			old_ui.queue_free()
			var new_ui = load("res://UI/Death Ui.tscn")
			var instance_new_ui = new_ui.instantiate()
			parent.add_child(instance_new_ui)
			set_game_speed(0)
		

func _unhandled_input(event):
	if event.is_action_pressed("Speedy"):
		if Engine.time_scale == clamp(1.0, 0.0, 10.0):
			set_game_speed(50)
		elif Engine.time_scale == clamp(50.0, 0.0, 10.0):
			set_game_speed(1)

func set_game_speed(scale: float) -> void:
	# Clamp to prevent negative or absurd values
	Engine.time_scale = clamp(scale, 0.0, 10.0)
	print("Game speed set to:", Engine.time_scale)

func _get_stick(index : int) -> PackedScene:
	var stick
	match index:
		0:
			stick = load(stick_slot1)
			return stick
		1:
			stick = load(stick_slot2)
			return stick
		2:
			stick = load(stick_slot3)
			return stick
		_:
			return null

func _get_ball(index : int) -> PackedScene:
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

func _get_stick_texture(index : int) -> Texture2D:
	var stick
	var texture
	match index:
		0:
			stick = load(stick_slot1)
			if stick == null:
				texture = null
				return
			var path = stick.get_path()
			var text = path.right(-path.rfind("/") - 1).left(-5)
			var new_path = str("res://Resources/Stick/" + text + ".tres")
			var res = load(new_path)
			texture = res.texture
			return texture
		1:
			stick = load(stick_slot2)
			if stick == null:
				texture = null
				return
			var path = stick.get_path()
			var text = path.right(-path.rfind("/") - 1).left(-5)
			var new_path = str("res://Resources/Stick/" + text + ".tres")
			var res = load(new_path)
			texture = res.texture
			return texture
		2:
			stick = load(stick_slot3)
			if stick == null:
				texture = null
				return
			var path = stick.get_path()
			var text = path.right(-path.rfind("/") - 1).left(-5)
			var new_path = str("res://Resources/Stick/" + text + ".tres")
			var res = load(new_path)
			texture = res.texture
			return texture
		_:
			return null

func _get_ball_texture(index : int) -> Texture2D:
	var ball
	var texture
	match index:
		0:
			ball = load(ball_slot1)
			if ball == null:
				return null
			var path = ball.get_path()
			var text = path.right(-path.rfind("/") - 1).left(-5)
			var new_path = str("res://Resources/Ball/" + text + ".tres")
			var res = load(new_path)
			var sprites = res.sprite_frames
			texture = sprites.get_frame_texture("default", 0)
			return texture
		1:
			ball = load(ball_slot2)
			if ball == null:
				return null
			var path = ball.get_path()
			var text = path.right(-path.rfind("/") - 1).left(-5)
			var new_path = str("res://Resources/Ball/" + text + ".tres")
			var res = load(new_path)
			var sprites = res.sprite_frames
			texture = sprites.get_frame_texture("default", 0)
			return texture
		2:
			ball = load(ball_slot3)
			if ball == null:
				return null
			var path = ball.get_path()
			var text = path.right(-path.rfind("/") - 1).left(-5)
			var new_path = str("res://Resources/Ball/" + text + ".tres")
			var res = load(new_path)
			var sprites = res.sprite_frames
			texture = sprites.get_frame_texture("default", 0)
			return texture
		_:
			return null


func clear_run_data():
	stick_slot1 = "res://Looting/Stick loot/Basic Stick.tscn"
	stick_slot2 = ""
	stick_slot3 = ""
	ball_slot1 = "res://Looting/Debug Ball.tscn"
	ball_slot2 = ""
	ball_slot3 = ""
	Stats.clear_all()
