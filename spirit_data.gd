class_name SpiritData extends Node

@export var startingAngerLevel: int
@export var angerThreshold: int
var angerLevel: int

@export var startingSadnessLevel: int
@export var sadnessThreshold: int
var sadnessLevel: int

func _ready() -> void:
	Reset()
	UpdateDisplay()

func AddAnger(amount: int) -> void:
	angerLevel += amount
	UpdateDisplay()
	
func AddSadness(amount: int) -> void:
	sadnessLevel += amount
	UpdateDisplay()
	
func UpdateDisplay() -> void:
	#%AngerLevel.text = str(angerLevel)
	#%SadnessLevel.text = str(sadnessLevel)
	pass
	
func DamagePlayerSanity(player: Player)->void:
	player.DrainSanity(randi_range(2, 15))

func CheckThresholds() -> bool:
	return angerLevel >= angerThreshold
	
func Reset() -> void:
	angerLevel = startingAngerLevel
	sadnessLevel = startingSadnessLevel
	
