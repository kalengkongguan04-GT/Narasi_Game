extends CharacterBody2D

var speed: float = 70.0
var move_distance: float = 100.0
var idle_time: float = 4.0
var player_masukBos = false

@onready var label = $Label
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D



func _ready():
	label.visible = false
	sprite.play("idle")

func _physics_process(delta):
	
	if player_masukBos and  Input.is_action_just_pressed("interact"):
		Dialogic.start("example1")
		
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_masukBos = true
		label.visible = true
		

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_masukBos = false
		label.visible = false
