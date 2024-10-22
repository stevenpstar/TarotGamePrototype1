extends TarotCard

func _init()->void:
	id = "ThreeOfSwords"

func on_draw(spirit: SpiritData)->void:
	spirit.AddSadness(50)
