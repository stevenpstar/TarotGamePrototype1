extends TarotCard

func _init()->void:
	id = "TheEmpress"

func on_draw(spirit: SpiritData)->void:
	spirit.SubtractAnger(20)
