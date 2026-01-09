extends Node

var lootpool : Array
var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lootpool = load_balls("res://Looting/Ball loot/")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_balls(folder_path: String) -> Array:
	var balls: Array = []
	var dir := DirAccess.open(folder_path)
	if dir == null:
		push_error("Could not open directory: " + folder_path)
		return balls
	# Skip hidden files and navigation entries
	dir.list_dir_begin()
	while true:
		var file_name := dir.get_next()
		if file_name == "":
			break
		if dir.current_is_dir():
			continue
		if file_name.ends_with(".tscn"):
			var full_path := folder_path + file_name
			var scene := load(full_path)
			if scene is PackedScene:
				balls.append(scene)
			else:
				push_warning("Failed to load scene: " + full_path)
	dir.list_dir_end()
	return balls

func get_item() -> PackedScene:
	var ball_index = random_ball()
	var ball = lootpool[ball_index]
	print("Selected ball: ", ball)
	return ball


func random_ball() -> int:
	var size = lootpool.size()
	var max = size * 100 - 1
	var tempRandom = rng.randi_range(0, max)
	while tempRandom > size-1:
		tempRandom -= size
	return tempRandom
