extends Node2D


@export var blackOverlay: CanvasItem
# @export var spotlightLayer: CanvasItem
# @export var spotlightMask: CanvasItem
@export var animationPlayer: AnimationPlayer
@export var dungeonFloor: Node2D
@export var tilemapLayer: TileMapLayer
@export var playerModel: Node2D
@export var spawnRoom: PackedScene


func _ready() -> void:
	# Safety checks (optional but recommended)
	assert(animationPlayer, "AnimationPlayer not assigned")
	assert(tilemapLayer, "TileMapLayer not assigned")
	assert(spawnRoom, "SpawnRoom scene not assigned")

	# Initial state
	tilemapLayer.visible = false

	# Play intro animation
	animationPlayer.play("Intro")

	# Wait 1.5 seconds, then show tilemap
	await get_tree().create_timer(1.5).timeout
	dungeonFloor.visible = true
	tilemapLayer.visible = true

	# Wait until animation fully finishes
	await animationPlayer.animation_finished

	# Hide tilemap again
	dungeonFloor.visible = false
	tilemapLayer.visible = false

	# Switch scene
	get_tree().change_scene_to_packed(spawnRoom)
