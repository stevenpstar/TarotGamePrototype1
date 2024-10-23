extends TarotCard

func _init()->void:
	id = "FourOfCups"

func on_draw(spirit: SpiritData)->void:
	spirit.AddSadness(20)
