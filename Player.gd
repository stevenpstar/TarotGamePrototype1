class_name Player extends Node

@export var startingSanity: int
var sanity: int

func _ready() -> void:
	Reset()

func AddSanity(amount: int)->void:
	sanity += amount

func DrainSanity(amount: int)->void:
	sanity -= amount
	print("sanity ", amount)

func Reset() -> void:
	sanity = startingSanity
