extends CharacterBody2D

@export var speed := 200
var isFlipped := false

@onready var anim_player: AnimationPlayer = $AnimationPlayer
const NORMAL_SCALE_X := 0.2  # Only use X scale

func _physics_process(_delta):
	var direction = Vector2.ZERO

	if Input.is_action_pressed("right"):
		direction.x = 1
	if Input.is_action_pressed("left"):
		direction.x = -1
	if Input.is_action_pressed("down"):
		direction.y = 1
	if Input.is_action_pressed("up"):
		direction.y = -1

	direction = direction.normalized()
	velocity = direction * speed
	move_and_slide()

	# -------------------------------
	# FLIP VISUALS
	# -------------------------------
	if direction.x < 0 and not isFlipped:
		scale.x = -NORMAL_SCALE_X
		isFlipped = true
	elif direction.x > 0 and isFlipped:
		scale.x = -NORMAL_SCALE_X ## Bruh, but works.
		isFlipped = false

	# -------------------------------
	# ANIMATION
	# -------------------------------
	if direction != Vector2.ZERO:
		if anim_player.current_animation != "WALK":
			anim_player.play("WALK")
	else:
		anim_player.play("RESET")
