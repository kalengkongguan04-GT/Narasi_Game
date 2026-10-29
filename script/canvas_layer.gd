extends CanvasLayer
@onready var color = $ColorRect
@onready var label = $Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	color.visible = true
	label.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
