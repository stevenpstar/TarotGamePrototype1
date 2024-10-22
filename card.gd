extends Area2D

var hovering: bool = false
var lateral: bool = false
var selected: bool = false

var desiredScale: Vector2 = Vector2(1,1)
const SCALE_RATE: float = 0.1
const SCALE_END: float = 1.0
const SCALE_START: float = 0.5
const MOVE_AMNT: float = 5.0

var startingPosition
var hoveredPosition
var lateralPosition

signal on_release(s)

@export var fortuneCardScript = GDScript
var fortuneCard

func _ready() -> void:
	fortuneCard = fortuneCardScript.new()

func _process(delta: float) -> void:
	scale.x = lerp(scale.x, desiredScale.x, SCALE_RATE)
	scale.y = lerp(scale.y, desiredScale.y, SCALE_RATE)
	if !selected and !lateral:
		moveCard(delta)
	elif !selected and lateral:
		moveLateral(delta)
	elif selected:
		position.x = lerp(position.x, get_global_mouse_position().x, 0.1)
		position.y = lerp(position.y, get_global_mouse_position().y, 0.1)
		
func _on_color_rect_mouse_entered() -> void:
	desiredScale.x = SCALE_END
	desiredScale.y = SCALE_END
	hovering = true
	%Highlight.visible = true
	%Highlight.color = Color(255.0, 255.0, 255.0, 255.0)
	z_index = 1

func _on_color_rect_mouse_exited() -> void:
	if !selected:
		releaseCard()
			
func moveCard(delta: float) -> void:
	if hovering:
		position.y = lerp(position.y, hoveredPosition.y, 0.3)
		position.x = lerp(position.x, hoveredPosition.x, 0.3)
	else:
		position.y = lerp(position.y, startingPosition.y, 0.3)
		position.x = lerp(position.x, startingPosition.x, 0.3)
		
func releaseCard() -> void:
	%Highlight.color = Color(0.0, 0.0, 0.0, 255.0)
	selected = false
	desiredScale.x = SCALE_START
	desiredScale.y = SCALE_START
	hovering = false
	z_index = 0
		
func _on_card_rect_gui_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("click"):
		%Highlight.color = Color(0.0, 0.0, 100.0, 255.0)
		selected = true
	elif Input.is_action_just_released("click"):
		if selected:
			on_release.emit(self)
		releaseCard()

func setStartingPosition(pos: Vector2) -> void:
	startingPosition = pos
	hoveredPosition = Vector2(startingPosition.x, startingPosition.y - 50)

func setMoveLateral(active: bool, diff: int, dir: int) -> void:
	lateral = active
	lateralPosition = startingPosition
	var move_amnt = 0.0
	if diff != 0:
		move_amnt = 1.0 / abs(diff)
	var tr = (35 * move_amnt) * dir
	if lateral:
		lateralPosition = Vector2(startingPosition.x + tr, startingPosition.y)

func moveLateral(delta: float) -> void:
	position.x = lerp(position.x, lateralPosition.x, 0.1)
	position.y = lerp(position.y, lateralPosition.y, 0.1)
