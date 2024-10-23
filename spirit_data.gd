class_name SpiritData extends Node

const maxSadness = 100
const maxAnger = 100
@export var startingAngerLevel: int
@export var angerThreshold: Vector2
var angerLevel: int

@export var startingSadnessLevel: int
@export var sadnessThreshold: Vector2
var sadnessLevel: int

func _ready() -> void:
	Reset()
	UpdateDisplay()

func AddAnger(amount: int) -> void:
	angerLevel += amount
	if angerLevel > maxAnger:
		angerLevel = maxAnger
	UpdateDisplay()
	
func AddSadness(amount: int) -> void:
	sadnessLevel += amount
	if sadnessLevel > maxSadness:
		sadnessLevel = maxSadness
	UpdateDisplay()
	
func SubtractSadness(amount: int) -> void:
	sadnessLevel -= amount
	if sadnessLevel < 0:
		sadnessLevel = 0
	UpdateDisplay()
	
func SubtractAnger(amount: int) -> void:
	angerLevel -= amount
	if angerLevel < 0:
		angerLevel = 0
	UpdateDisplay()
	
func UpdateDisplay() -> void:
	#%AngerLevel.text = str(angerLevel)
	#%SadnessLevel.text = str(sadnessLevel)
	pass
	
func DamagePlayerSanity(player: Player)->void:
	player.DrainSanity(randi_range(2, 15))

func CheckThresholds() -> bool:
	return angerLevel >= angerThreshold.x && angerLevel <= angerThreshold.y && sadnessLevel >= sadnessThreshold.x && sadnessLevel <= sadnessThreshold.y
	
func Reset() -> void:
	angerLevel = startingAngerLevel
	sadnessLevel = startingSadnessLevel
	
