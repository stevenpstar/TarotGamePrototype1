extends TarotCard

func _init()->void:
	id = "Death"

func on_draw(spirit: SpiritData)->void:
	spirit.AddSadness(20)
	spirit.AddAnger(20)
