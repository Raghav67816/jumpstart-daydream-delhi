extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -350.0

var coins = 0
@onready var anim = $AnimatedSprite2D

func _ready():
	anim.play("idle")
	# Auto-connect all coin signals
	for coin in get_tree().get_nodes_in_group("coin"):
		coin.connect("add_coin", Callable(self, "_on_coin_add_coin"))

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_pressed("ui_up"):
		anim.play("jump")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		if direction < 0: anim.play("run"); anim.flip_h = true
		if direction > 0: anim.play("run"); anim.flip_h = false
		if direction == 0: anim.play("idle")
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_coin_add_coin() -> void:
	print("got a coin")
	coins += 1
	$Coins.text = "Coins: {coin_count}".format({'coin_count': coins})
