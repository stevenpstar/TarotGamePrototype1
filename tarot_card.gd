extends Area2D

var startingPosition

@export var cardScript = GDScript
var card

func _ready()->void:
	card = cardScript.new()

func _process(delta: float) -> void:
	moveCard(delta)

func moveCard(delta: float) -> void:
	position.y = lerp(position.y, startingPosition.y, 0.3)
	position.x = lerp(position.x, startingPosition.x, 0.3)
