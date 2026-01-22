extends Node2D

@export var blackOverlay: CanvasItem
@export var animationPlayer: AnimationPlayer
@export var dungeonFloor: Node2D
@export var tilemapLayer: TileMapLayer
@export var playerModel: Node2D
@export var spawnRoom: PackedScene
@export var skipButton: Button

var skipped := false


func _ready() -> void:
	assert(animationPlayer)
	assert(tilemapLayer)
	assert(spawnRoom)

	# Initial state
	dungeonFloor.visible = false
	tilemapLayer.visible = false

	# Connect skip button
	if skipButton:
		skipButton.pressed.connect(_on_skip_pressed)

	# Play intro
	animationPlayer.play("Intro")

	# Show dungeon after delay
	await get_tree().create_timer(1.5).timeout
	if skipped:
		return

	dungeonFloor.visible = true
	tilemapLayer.visible = true

	# Wait for animation to finish
	await animationPlayer.animation_finished
	if skipped:
		return

	_finish_intro()


func _on_skip_pressed() -> void:
	if skipped:
		return

	skipped = true

	# Stop animation immediately
	if animationPlayer.is_playing():
		animationPlayer.stop()

	_finish_intro()


func _finish_intro() -> void:
	# Prevent double execution
	if skipped == false:
		skipped = true

	# Clean state (optional but neat)
	dungeonFloor.visible = false
	tilemapLayer.visible = false

	# Transition
	get_tree().change_scene_to_packed(spawnRoom)
