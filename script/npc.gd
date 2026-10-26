extends CharacterBody2D

@export var speed: float = 70.0
@export var move_distance: float = 100.0
@export var idle_time: float = 4.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var start_x: float
var left_limit: float
var right_limit: float
var direction: int = 1
var idle_timer: float = 0.0
var is_idle: bool = false

func _ready():
	start_x = position.x
	left_limit = start_x - move_distance
	right_limit = start_x + move_distance
	sprite.play("move")

func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if is_idle:
		velocity.x = 0
		idle_timer -= delta
		sprite.play("idle")
		
		if idle_timer <= 0:
			is_idle = false
			direction *= -1
			sprite.play("move")
			
	else:
		velocity.x = direction * speed
		sprite.flip_h = direction < 0
		
		if direction == 1 and position.x >= right_limit:
			position.x = right_limit
			is_idle = true
			idle_timer = idle_time
			
		elif direction == -1 and position.x <= left_limit:
			position.x = left_limit
			is_idle = true
			idle_timer = idle_time
			
		if is_idle:
			velocity.x = 0
			
	move_and_slide()
