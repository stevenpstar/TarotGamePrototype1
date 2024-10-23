extends TarotCard

func _init()->void:
	id = "TheHangedMan"

func on_draw(spirit: SpiritData)->void:
	spirit.SubtractSadness(20)
	spirit.AddFear(20)
