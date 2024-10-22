extends FortuneCard

func _init() -> void:
	cost = 1

func on_draw(spirit: SpiritData, player: Player)->void:
	pass

func on_play(spirit: SpiritData, player: Player, callable: Callable)->void:
	player.DrainSanity(cost)
	spirit.AddSadness(1)
	callable.call(3)
	
func on_play_past(spirit: SpiritData, card: TarotCard, player: Player)->void:
	player.DrainSanity(cost)
	if card.id == "ThreeOfSwords":
		spirit.AddSadness(50)
	else:
		spirit.AddSadness(2)

func on_start_past(spirit: SpiritData, card: TarotCard, player: Player) -> void:
	player.AddSanity(2)
	spirit.AddSadness(5)
